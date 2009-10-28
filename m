Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZJ1GJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZJ1GJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZJ1GJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:09:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:22733 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794AbZJ1GJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,638,1249282800"; 
   d="scan'208";a="508295602"
From: "Ma, Ling" <ling.ma@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Oct 2009 14:09:26 +0800
Subject: FW: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S
 by avoid memory miss predication.
Thread-Topic: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S
 by avoid memory miss predication.
Thread-Index: AcpWFeUp58zm1h1GRQuSWnpWUjUi5QBe2IvAAADhZiAAABTQIA==
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FCDE2430@PDSMSX501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9S69t16027246

Hi Ingo
There are another test cases we need to do or comments?

Best Regards
Ma Ling

________________________________________
From: Ma, Ling 
Sent: 2009年10月26日 16:26
To: 'mingo@elte.hu'
Cc: 'hpa@zytor.com'; 'tglx@linutronix.de'; 'linux-kernel@vger.kernel.org'
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by avoid memory miss predication.


We generate new report for another case when src offset is 0x45010, dst is 0x34020.
by 'perf stat --repeat 10 ./static_rsi_45010_rdi_34020_old/new' .
 
The test program I wrote:
 for (i = 64; i < 4096 *4; i ++)
      do_memcpy(src, dst, i);
 
 
Before the patch:
Performance counter stats for './static_rsi_45010_rdi_34020_old' (10 runs):          
                                                                                     
  54014.766012  task-clock-msecs         #      0.999 CPUs    ( +-   0.016% )        
             80  context-switches         #      0.000 M/sec   ( +-   7.894% )        
              0  CPU-migrations           #      0.000 M/sec   ( +-  66.667% )        
          4429  page-faults              #      0.000 M/sec   ( +-   0.002% )        
 136855571663  cycles                   #   2533.670 M/sec   ( +-   0.016% )        
  44524796868  instructions             #      0.325 IPC     ( +-   0.008% )        
        771000  cache-references         #      0.014 M/sec   ( +-  10.397% )        
        541785  cache-misses             #      0.010 M/sec   ( +-   4.203% )        
                                                                                     
  54.062799203  seconds time elapsed   ( +-   0.021% )                               
                                                                                     
After the patch                                                                                     
Performance counter stats for './static_rsi_45010_rdi_34020_new' (10 runs):          
                                                                                     
   7570.357661  task-clock-msecs         #      0.999 CPUs    ( +-   0.350% )        
            13  context-switches         #      0.000 M/sec   ( +-   9.320% )        
             0  CPU-migrations           #      0.000 M/sec   ( +-     nan% )        
         4429  page-faults              #      0.001 M/sec   ( +-   0.004% )        
 19180782064  cycles                   #   2533.669 M/sec   ( +-   0.349% )        
 44462001104  instructions             #      2.318 IPC     ( +-   0.001% )        
       383673  cache-references         #      0.051 M/sec   ( +-   4.112% )        
       317436  cache-misses             #      0.042 M/sec   ( +-   1.607% )        
                                                                                     
   7.581541785  seconds time elapsed   ( +-   0.343% )      
                          
The patch got performance improvement 54.062799203/ 7.581541785  = 7.13x.
If you need any other test reports, please let me know
 
Thanks
Ma Ling


���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
