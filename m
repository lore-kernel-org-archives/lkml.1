Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbYEEQxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbYEEQxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYEEQwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:52:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53531 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYEEQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:52:53 -0400
Message-ID: <481F3B62.9020407@bull.net>
Date: Mon, 05 May 2008 18:52:50 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [PATCH 00/10] Scalability requirements for sysv ipc - v2
References: <20080429143304.741001000@bull.net> <20080429115424.41b82fcb.akpm@linux-foundation.org>
In-Reply-To: <20080429115424.41b82fcb.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------050505000702050906010402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050505000702050906010402
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue, 29 Apr 2008 16:33:04 +0200
> Nadia.Derbey@bull.net wrote:
> 
> 
>>After scalability problems had been detected when using the sysV ipcs, I
>>have proposed to use an RCU based implementation of the IDR api instead
>>(see thread http://lkml.org/lkml/2008/4/11/212).
>>
>>Resending the patch series after
>> . integrating Paul's remarks
>> . fixing a bug I had introduced
>> . porting it to 2.6.25-mm1.
>>
>>Reviewers are still welcome!
>>
>>Patch 1 can be taken alone: it fixes a problem in the existing IDR API.
>>
>>Patches should be applied on linux-2.6.25-mm1, in the following order:
>>
>>[ PATCH 01/10 ] : idr_minor_fix.patch
>>[ PATCH 02/10 ] : ridr_structure.patch
>>[ PATCH 03/10 ] : ridr_pre_get.patch
>>[ PATCH 04/10 ] : ridr_init.patch
>>[ PATCH 05/10 ] : ridr_get_new_above.patch
>>[ PATCH 06/10 ] : ridr_get_new.patch
>>[ PATCH 07/10 ] : ridr_find.patch
>>[ PATCH 08/10 ] : ridr_remove.patch
>>[ PATCH 09/10 ] : ipc_use_ridr.patch
>>[ PATCH 10/10 ] : remove_ipc_lock_down.patch
>>
> 
> 
> hm, you've been busy.
> 
> As all this work is entirely for performance reasons, the changelog should
> have (lots of) performance testing results!  Please.
> 
> 

Here are the results I've got  for the pmsg test sent by Manfred:

for i in 1 2 3 4 5 6 7 8;do ./pmsg $i 5;done > output.25_mm1.ref.8
for i in 1 2 3 4 5 6 7 8;do ./pmsg $i 5;done > output.25_mm1.patch.8


                 2.6.25-mm1 (ref)   2.6.25-mm1(patched)

Total (1 cpu):   876000             985496
Total (2 cpus): 1549592            1740591
Total (3 cpus): 1694370            2327468
Total (4 cpus):  404553            2465787
Total (5 cpus):  391283            3215676
Total (6 cpus):  263249            3849121
Total (7 cpus):  191742            4209866
Total (8 cpus):  141722            4255585



Full output files attached.

Will send the rest tomorrow.

Regards
Nadia


--------------050505000702050906010402
Content-Type: text/x-troff-man;
 name="output.25_mm1.ref.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.25_mm1.ref.8"

pmsg [nr queues] [timeout]
Using 1 queues/cpus (2 threads) for 5 seconds.
thread 1: sysvmsg        0 type 0 bound to 0001h
thread 0: sysvmsg        0 type 1 bound to 0001h
Result matrix:
  Thread   0:   438000       1:   438000
Total: 876000
pmsg [nr queues] [timeout]
Using 2 queues/cpus (4 threads) for 5 seconds.
thread 0: sysvmsg    32768 type 1 bound to 0001h
thread 1: sysvmsg    65537 type 1 bound to 0002h
thread 3: sysvmsg    65537 type 0 bound to 0002h
thread 2: sysvmsg    32768 type 0 bound to 0001h
Result matrix:
  Thread   0:   385675       2:   385675
  Thread   1:   389121       3:   389121
Total: 1549592
pmsg [nr queues] [timeout]
Using 3 queues/cpus (6 threads) for 5 seconds.
thread 0: sysvmsg    98304 type 1 bound to 0001h
thread 3: sysvmsg    98304 type 0 bound to 0001h
thread 1: sysvmsg   131073 type 1 bound to 0002h
thread 2: sysvmsg   163842 type 1 bound to 0004h
thread 5: sysvmsg   163842 type 0 bound to 0004h
thread 4: sysvmsg   131073 type 0 bound to 0002h
Result matrix:
  Thread   0:   279690       3:   279690
  Thread   1:   283228       4:   283229
  Thread   2:   284266       5:   284267
Total: 1694370
pmsg [nr queues] [timeout]
Using 4 queues/cpus (8 threads) for 5 seconds.
thread 0: sysvmsg   196608 type 1 bound to 0001h
thread 1: sysvmsg   229377 type 1 bound to 0002h
thread 2: sysvmsg   262146 type 1 bound to 0004h
thread 3: sysvmsg   294915 type 1 bound to 0008h
thread 4: sysvmsg   196608 type 0 bound to 0001h
thread 7: sysvmsg   294915 type 0 bound to 0008h
thread 6: sysvmsg   262146 type 0 bound to 0004h
thread 5: sysvmsg   229377 type 0 bound to 0002h
Result matrix:
  Thread   0:    50305       4:    50305
  Thread   1:    50168       5:    50168
  Thread   2:    50922       6:    50922
  Thread   3:    50881       7:    50882
Total: 404553
pmsg [nr queues] [timeout]
Using 5 queues/cpus (10 threads) for 5 seconds.
thread 0: sysvmsg   327680 type 1 bound to 0001h
thread 1: sysvmsg   360449 type 1 bound to 0002h
thread 2: sysvmsg   393218 type 1 bound to 0004h
thread 3: sysvmsg   425987 type 1 bound to 0008h
thread 4: sysvmsg   458756 type 1 bound to 0010h
thread 8: sysvmsg   425987 type 0 bound to 0008h
thread 7: sysvmsg   393218 type 0 bound to 0004h
thread 6: sysvmsg   360449 type 0 bound to 0002h
thread 5: sysvmsg   327680 type 0 bound to 0001h
thread 9: sysvmsg   458756 type 0 bound to 0010h
Result matrix:
  Thread   0:    29684       5:    29684
  Thread   1:    30236       6:    30237
  Thread   2:    30902       7:    30902
  Thread   3:    30699       8:    30700
  Thread   4:    74119       9:    74120
Total: 391283
pmsg [nr queues] [timeout]
Using 6 queues/cpus (12 threads) for 5 seconds.
thread 0: sysvmsg   491520 type 1 bound to 0001h
thread 2: sysvmsg   557058 type 1 bound to 0004h
thread 7: sysvmsg   524289 type 0 bound to 0002h
thread 1: sysvmsg   524289 type 1 bound to 0002h
thread 8: sysvmsg   557058 type 0 bound to 0004h
thread 3: sysvmsg   589827 type 1 bound to 0008h
thread 6: sysvmsg   491520 type 0 bound to 0001h
thread 4: sysvmsg   622596 type 1 bound to 0010h
thread 11: sysvmsg   655365 type 0 bound to 0020h
thread 5: sysvmsg   655365 type 1 bound to 0020h
thread 10: sysvmsg   622596 type 0 bound to 0010h
thread 9: sysvmsg   589827 type 0 bound to 0008h
Result matrix:
  Thread   0:    17229       6:    17230
  Thread   1:    17442       7:    17442
  Thread   2:    17337       8:    17337
  Thread   3:    17420       9:    17421
  Thread   4:    31020      10:    31020
  Thread   5:    31175      11:    31176
Total: 263249
pmsg [nr queues] [timeout]
Using 7 queues/cpus (14 threads) for 5 seconds.
thread 0: sysvmsg   688128 type 1 bound to 0001h
thread 1: sysvmsg   720897 type 1 bound to 0002h
thread 2: sysvmsg   753666 type 1 bound to 0004h
thread 3: sysvmsg   786435 type 1 bound to 0008h
thread 4: sysvmsg   819204 type 1 bound to 0010h
thread 5: sysvmsg   851973 type 1 bound to 0020h
thread 6: sysvmsg   884742 type 1 bound to 0040h
thread 8: sysvmsg   720897 type 0 bound to 0002h
thread 10: sysvmsg   786435 type 0 bound to 0008h
thread 9: sysvmsg   753666 type 0 bound to 0004h
thread 11: sysvmsg   819204 type 0 bound to 0010h
thread 7: sysvmsg   688128 type 0 bound to 0001h
thread 13: sysvmsg   884742 type 0 bound to 0040h
thread 12: sysvmsg   851973 type 0 bound to 0020h
Result matrix:
  Thread   0:    12058       7:    12058
  Thread   1:    12054       8:    12055
  Thread   2:    12023       9:    12023
  Thread   3:    12062      10:    12062
  Thread   4:    15940      11:    15940
  Thread   5:    15725      12:    15726
  Thread   6:    16008      13:    16008
Total: 191742
pmsg [nr queues] [timeout]
Using 8 queues/cpus (16 threads) for 5 seconds.
thread 1: sysvmsg   950273 type 1 bound to 0002h
thread 2: sysvmsg   983042 type 1 bound to 0004h
thread 3: sysvmsg  1015811 type 1 bound to 0008h
thread 4: sysvmsg  1048580 type 1 bound to 0010h
thread 0: sysvmsg   917504 type 1 bound to 0001h
thread 8: sysvmsg   917504 type 0 bound to 0001h
thread 10: sysvmsg   983042 type 0 bound to 0004h
thread 9: sysvmsg   950273 type 0 bound to 0002h
thread 12: sysvmsg  1048580 type 0 bound to 0010h
thread 11: sysvmsg  1015811 type 0 bound to 0008h
thread 5: sysvmsg  1081349 type 1 bound to 0020h
thread 6: sysvmsg  1114118 type 1 bound to 0040h
thread 13: sysvmsg  1081349 type 0 bound to 0020h
thread 7: sysvmsg  1146887 type 1 bound to 0080h
thread 14: sysvmsg  1114118 type 0 bound to 0040h
thread 15: sysvmsg  1146887 type 0 bound to 0080h
Result matrix:
  Thread   0:     8757       8:     8757
  Thread   1:     8819       9:     8819
  Thread   2:     8848      10:     8849
  Thread   3:     8832      11:     8832
  Thread   4:     8930      12:     8931
  Thread   5:     8893      13:     8894
  Thread   6:     8894      14:     8894
  Thread   7:     8886      15:     8887
Total: 141722

--------------050505000702050906010402
Content-Type: text/x-troff-man;
 name="output.25_mm1.patch.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.25_mm1.patch.8"

pmsg [nr queues] [timeout]
Using 1 queues/cpus (2 threads) for 5 seconds.
thread 0: sysvmsg  1507328 type 1 bound to 0001h
thread 1: sysvmsg  1507328 type 0 bound to 0001h
Result matrix:
  Thread   0:   492748       1:   492748
Total: 985496
pmsg [nr queues] [timeout]
Using 2 queues/cpus (4 threads) for 5 seconds.
thread 0: sysvmsg  1540096 type 1 bound to 0001h
thread 1: sysvmsg  1572865 type 1 bound to 0002h
thread 3: sysvmsg  1572865 type 0 bound to 0002h
thread 2: sysvmsg  1540096 type 0 bound to 0001h
Result matrix:
  Thread   0:   436429       2:   436430
  Thread   1:   433866       3:   433866
Total: 1740591
pmsg [nr queues] [timeout]
Using 3 queues/cpus (6 threads) for 5 seconds.
thread 0: sysvmsg  1605632 type 1 bound to 0001h
thread 1: sysvmsg  1638401 type 1 bound to 0002h
thread 2: sysvmsg  1671170 type 1 bound to 0004h
thread 5: sysvmsg  1671170 type 0 bound to 0004h
thread 4: sysvmsg  1638401 type 0 bound to 0002h
thread 3: sysvmsg  1605632 type 0 bound to 0001h
Result matrix:
  Thread   0:   388457       3:   388457
  Thread   1:   384674       4:   384674
  Thread   2:   390603       5:   390603
Total: 2327468
pmsg [nr queues] [timeout]
Using 4 queues/cpus (8 threads) for 5 seconds.
thread 0: sysvmsg  1703936 type 1 bound to 0001h
thread 1: sysvmsg  1736705 type 1 bound to 0002h
thread 2: sysvmsg  1769474 type 1 bound to 0004h
thread 3: sysvmsg  1802243 type 1 bound to 0008h
thread 6: sysvmsg  1769474 type 0 bound to 0004h
thread 5: sysvmsg  1736705 type 0 bound to 0002h
thread 7: sysvmsg  1802243 type 0 bound to 0008h
thread 4: sysvmsg  1703936 type 0 bound to 0001h
Result matrix:
  Thread   0:   307122       4:   307122
  Thread   1:   308710       5:   308711
  Thread   2:   307589       6:   307589
  Thread   3:   309472       7:   309472
Total: 2465787
pmsg [nr queues] [timeout]
Using 5 queues/cpus (10 threads) for 5 seconds.
thread 0: sysvmsg  1835008 type 1 bound to 0001h
thread 1: sysvmsg  1867777 type 1 bound to 0002h
thread 2: sysvmsg  1900546 type 1 bound to 0004h
thread 3: sysvmsg  1933315 type 1 bound to 0008h
thread 4: sysvmsg  1966084 type 1 bound to 0010h
thread 7: sysvmsg  1900546 type 0 bound to 0004h
thread 9: sysvmsg  1966084 type 0 bound to 0010h
thread 8: sysvmsg  1933315 type 0 bound to 0008h
thread 6: sysvmsg  1867777 type 0 bound to 0002h
thread 5: sysvmsg  1835008 type 0 bound to 0001h
Result matrix:
  Thread   0:   338483       5:   338483
  Thread   1:   266569       6:   266569
  Thread   2:   285255       7:   285256
  Thread   3:   335819       8:   335819
  Thread   4:   381711       9:   381712
Total: 3215676
pmsg [nr queues] [timeout]
Using 6 queues/cpus (12 threads) for 5 seconds.
thread 0: sysvmsg  1998848 type 1 bound to 0001h
thread 2: sysvmsg  2064386 type 1 bound to 0004h
thread 7: sysvmsg  2031617 type 0 bound to 0002h
thread 3: sysvmsg  2097155 type 1 bound to 0008h
thread 4: sysvmsg  2129924 type 1 bound to 0010h
thread 5: sysvmsg  2162693 type 1 bound to 0020h
thread 8: sysvmsg  2064386 type 0 bound to 0004h
thread 1: sysvmsg  2031617 type 1 bound to 0002h
thread 6: sysvmsg  1998848 type 0 bound to 0001h
thread 11: sysvmsg  2162693 type 0 bound to 0020h
thread 10: sysvmsg  2129924 type 0 bound to 0010h
thread 9: sysvmsg  2097155 type 0 bound to 0008h
Result matrix:
  Thread   0:   318850       6:   318850
  Thread   1:   307664       7:   307664
  Thread   2:   316157       8:   316157
  Thread   3:   274740       9:   274741
  Thread   4:   352108      10:   352109
  Thread   5:   355040      11:   355041
Total: 3849121
pmsg [nr queues] [timeout]
Using 7 queues/cpus (14 threads) for 5 seconds.
thread 1: sysvmsg  2228225 type 1 bound to 0002h
thread 7: sysvmsg  2195456 type 0 bound to 0001h
thread 2: sysvmsg  2260994 type 1 bound to 0004h
thread 3: sysvmsg  2293763 type 1 bound to 0008h
thread 4: sysvmsg  2326532 type 1 bound to 0010h
thread 5: sysvmsg  2359301 type 1 bound to 0020h
thread 13: sysvmsg  2392070 type 0 bound to 0040h
thread 9: sysvmsg  2260994 type 0 bound to 0004h
thread 8: sysvmsg  2228225 type 0 bound to 0002h
thread 0: sysvmsg  2195456 type 1 bound to 0001h
thread 12: sysvmsg  2359301 type 0 bound to 0020h
thread 6: sysvmsg  2392070 type 1 bound to 0040h
thread 11: sysvmsg  2326532 type 0 bound to 0010h
thread 10: sysvmsg  2293763 type 0 bound to 0008h
Result matrix:
  Thread   0:   311401       7:   311402
  Thread   1:   255123       8:   255124
  Thread   2:   311868       9:   311868
  Thread   3:   299011      10:   299011
  Thread   4:   280114      11:   280115
  Thread   5:   314069      12:   314070
  Thread   6:   333345      13:   333345
Total: 4209866
pmsg [nr queues] [timeout]
Using 8 queues/cpus (16 threads) for 5 seconds.
thread 0: sysvmsg  2424832 type 1 bound to 0001h
thread 1: sysvmsg  2457601 type 1 bound to 0002h
thread 2: sysvmsg  2490370 type 1 bound to 0004h
thread 3: sysvmsg  2523139 type 1 bound to 0008h
thread 4: sysvmsg  2555908 type 1 bound to 0010h
thread 5: sysvmsg  2588677 type 1 bound to 0020h
thread 6: sysvmsg  2621446 type 1 bound to 0040h
thread 7: sysvmsg  2654215 type 1 bound to 0080h
thread 10: sysvmsg  2490370 type 0 bound to 0004h
thread 13: sysvmsg  2588677 type 0 bound to 0020h
thread 9: sysvmsg  2457601 type 0 bound to 0002h
thread 12: sysvmsg  2555908 type 0 bound to 0010h
thread 11: sysvmsg  2523139 type 0 bound to 0008h
thread 8: sysvmsg  2424832 type 0 bound to 0001h
thread 14: sysvmsg  2621446 type 0 bound to 0040h
thread 15: sysvmsg  2654215 type 0 bound to 0080h
Result matrix:
  Thread   0:   234942       8:   234942
  Thread   1:   262977       9:   262978
  Thread   2:   294207      10:   294208
  Thread   3:   288878      11:   288879
  Thread   4:   273532      12:   273532
  Thread   5:   248904      13:   248904
  Thread   6:   260121      14:   260122
  Thread   7:   264229      15:   264230
Total: 4255585

--------------050505000702050906010402--
