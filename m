Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZD1F0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZD1F0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZD1F0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:26:31 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:53761 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZD1F0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:26:31 -0400
Message-ID: <49F6936E.9020005@cosmosbay.com>
Date: Tue, 28 Apr 2009 07:26:06 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Subject: Re: Discrepancies between Oprofile and vmstat II
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com> <87ljpmk29b.fsf@basil.nowhere.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com> <20090427185305.GG27382@one.firstfloor.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459877BD@azsmsx501.amr.corp.intel.com> <20090427222242.GJ27382@one.firstfloor.org>
In-Reply-To: <20090427222242.GJ27382@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 28 Apr 2009 07:26:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> On Mon, Apr 27, 2009 at 03:15:27PM -0700, Styner, Douglas W wrote:
>>> I believe so, but will confirm.
>>>
>>>> opcontrol -e=CPU_CLK_UNHALTED:80000 -e=LLC_MISSES:6000
>>>>
>>>> Using another profiling tool to confirm, we see 74.784% user, 25.174% > > kernel.
>>> Just verifying -- you also see it when you use a shorter period than 80000 > right?
>> Confirmed.  Changes in profile appear to be due to increased sampling by oprofile with lower value.
> 
> You mean "with higher value", right ?
> 
> It's still strange that it suddenly changed in 2.6.27 though. There shouldn't have been
> a difference there. So I still think it's a regression.
> 

An oprofile regression ? Oh no !

;) Just kidding

Introduction of ring buffers was probably the start of oprofile using more cpu cycles,
and I remember seeing rb_get_reader_page() and ring_buffer_consume()
climbing in top 10 functions on tbench oprofile session.

CPU: Core 2, speed 3000.46 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 10000
samples  cum. samples  %        cum. %     symbol name
731641   731641        10.0572  10.0572    copy_from_user
328634   1060275        4.5174  14.5746    copy_to_user
269686   1329961        3.7071  18.2817    ipt_do_table
254019   1583980        3.4918  21.7735    __schedule
205152   1789132        2.8200  24.5935    tcp_ack
202930   1992062        2.7895  27.3830    rb_get_reader_page   rank 6
170751   2162813        2.3472  29.7301    tcp_sendmsg
152271   2315084        2.0931  31.8233    ring_buffer_consume  rank 8
147362   2462446        2.0256  33.8489    tcp_recvmsg
138150   2600596        1.8990  35.7479    tcp_transmit_skb
134191   2734787        1.8446  37.5925    ip_queue_xmit
125952   2860739        1.7313  39.3239    sysenter_past_esp
112158   2972897        1.5417  40.8656    tcp_rcv_established
106236   3079133        1.4603  42.3259    __switch_to
105435   3184568        1.4493  43.7752    tcp_v4_rcv
97660    3282228        1.3424  45.1177    netif_receive_skb
89327    3371555        1.2279  46.3456    dst_release
78746    3450301        1.0824  47.4280    dev_queue_xmit
74776    3525077        1.0279  48.4559    release_sock
72979    3598056        1.0032  49.4591    lock_sock_nested
72031    3670087        0.9901  50.4492    tcp_event_data_recv
71130    3741217        0.9778  51.4270    tcp_write_xmit
69475    3810692        0.9550  52.3820    __inet_lookup_established
66537    3877229        0.9146  53.2966    nf_iterate
60504    3937733        0.8317  54.1283    ip_rcv
55767    3993500        0.7666  54.8949    sys_socketcall
53273    4046773        0.7323  55.6272    update_curr
49315    4096088        0.6779  56.3051    ip_finish_output
48958    4145046        0.6730  56.9780    __alloc_skb
48440    4193486        0.6659  57.6439    skb_release_data
46166    4239652        0.6346  58.2785    page_address
46147    4285799        0.6343  58.9128    local_bh_enable
43867    4329666        0.6030  59.5158    netif_rx
43671    4373337        0.6003  60.1161    put_page
43554    4416891        0.5987  60.7148    __update_sched_clock
42899    4459790        0.5897  61.3045    get_page_from_freelist
42747    4502537        0.5876  61.8921    sched_clock_cpu


Also other rb functions use some cycles...

c0261580 <rb_advance_reader>: /* rb_advance_reader total:  95595  0.4967 */
c0261cf0 <rb_buffer_peek>: /* rb_buffer_peek total:  75520  0.3924 */
c0260d80 <rb_event_length>: /* rb_event_length total:  70396  0.3658 */
c0260dd0 <ring_buffer_event_length>: /* ring_buffer_event_length total:  31028  0.1612 */
c02613b0 <ring_buffer_event_data>: /* ring_buffer_event_data total:  20663  0.1074 */

Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 10000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
 12062103 80.0850 vmlinux
  1319946  8.7636 libc-2.3.4.so
  1089407  7.2330 tbench
        CPU_CLK_UNHALT...|
          samples|      %|
        ------------------
          1089406 99.9999 tbench
                1 9.2e-05 [heap] (tgid:16048 range:0x804e000-0x8080000)
   403877  2.6815 oprofile
   107343  0.7127 tbench_srv
    55018  0.3653 oprofiled

c02613e0 <rb_get_reader_page>: /* rb_get_reader_page total: 534995  2.7800 */
 13316  0.0692 :c02613e0:       push   %ebp
     5 2.6e-05 :c02613e1:       mov    %esp,%ebp
               :c02613e3:       push   %edi
  6864  0.0357 :c02613e4:       push   %esi
    11 5.7e-05 :c02613e5:       push   %ebx
    14 7.3e-05 :c02613e6:       sub    $0x1c,%esp
  6738  0.0350 :c02613e9:       pushf
 27140  0.1410 :c02613ea:       popl   0x10(%esp)
 13627  0.0708 :c02613ee:       cli
 27016  0.1404 :c02613ef:       lea    0xc(%eax),%edx
    17 8.8e-05 :c02613f2:       mov    %edx,0x14(%esp)
    16 8.3e-05 :c02613f6:       mov    $0x100,%edx
  6765  0.0352 :c02613fb:       mov    0x14(%esp),%ecx
    20 1.0e-04 :c02613ff:       lock xadd %dx,(%ecx)
142726  0.7417 :c0261404:       cmp    %dh,%dl
    11 5.7e-05 :c0261406:       je     c026140e <rb_get_reader_page+0x2e>
               :c0261408:       pause
               :c026140a:       mov    (%ecx),%dl
               :c026140c:       jmp    c0261404 <rb_get_reader_page+0x24>
  6724  0.0349 :c026140e:       mov    0x24(%eax),%ebx
 67811  0.3524 :c0261411:       mov    0x4(%ebx),%edx
 27227  0.1415 :c0261414:       mov    0x10(%ebx),%ecx
  6908  0.0359 :c0261417:       mov    0x8(%ecx),%esi
 21286  0.1106 :c026141a:       cmp    %esi,%edx
     4 2.1e-05 :c026141c:       jb     c0261528 <rb_get_reader_page+0x148>
     8 4.2e-05 :c0261422:       mov    0x8(%ecx),%ecx
   197  0.0010 :c0261425:       cmp    %ecx,%edx
    13 6.8e-05 :c0261427:       ja     c02614fa <rb_get_reader_page+0x11a>
    12 6.2e-05 :c026142d:       cmp    %ebx,0x20(%eax)
    12 6.2e-05 :c0261430:       je     c0261540 <rb_get_reader_page+0x160>
    13 6.8e-05 :c0261436:       lea    0x10(%eax),%esi
    95 4.9e-04 :c0261439:       mov    $0x1,%edx
               :c026143e:       mov    %esi,0x18(%esp)
    45 2.3e-04 :c0261442:       jmp    c0261494 <rb_get_reader_page+0xb4>
               :c0261444:       lea    0x0(%esi,%eiz,1),%esi
    24 1.2e-04 :c0261448:       sub    $0x8,%ebx
    43 2.2e-04 :c026144b:       mov    %ebx,0x18(%eax)
    36 1.9e-04 :c026144e:       mov    %ecx,0x24(%eax)
    80 4.2e-04 :c0261451:       inc    %edx
               :c0261452:       mov    0x10(%ecx),%ebx
               :c0261455:       cmp    $0x4,%edx
...
  6952  0.0361 :c0261528:       mov    0x14(%esp),%edx
   203  0.0011 :c026152c:       incb   0xc(%eax)
  6789  0.0353 :c026152f:       pushl  0x10(%esp)
    30 1.6e-04 :c0261533:       popf
108826  0.5655 :c0261534:       add    $0x1c,%esp
   322  0.0017 :c0261537:       mov    %ebx,%eax
               :c0261539:       pop    %ebx
 13921  0.0723 :c026153a:       pop    %esi
  6689  0.0348 :c026153b:       pop    %edi
  6884  0.0358 :c026153c:       leave
  6791  0.0353 :c026153d:       ret
               :c026153e:       xchg   %ax,%ax
     2 1.0e-05 :c0261540:       xor    %ebx,%ebx
     7 3.6e-05 :c0261542:       jmp    c0261528 <rb_get_reader_page+0x148>
               :c0261544:       lea    0x40(%eax),%edx


c0261de0 <ring_buffer_consume>: /* ring_buffer_consume total: 395772  2.0566 */
  6854  0.0356 :c0261de0:       push   %ebp
    26 1.4e-04 :c0261de1:       mov    %esp,%ebp
               :c0261de3:       push   %edi
 12755  0.0663 :c0261de4:       mov    %eax,%edi
               :c0261de6:       push   %esi
   182 9.5e-04 :c0261de7:       add    $0x10,%edi
               :c0261dea:       push   %ebx
  5464  0.0284 :c0261deb:       xor    %esi,%esi
               :c0261ded:       sub    $0x18,%esp
    42 2.2e-04 :c0261df0:       mov    %edx,%ebx
  3494  0.0182 :c0261df2:       mov    %eax,-0x18(%ebp)
   301  0.0016 :c0261df5:       mov    %ecx,-0x24(%ebp)
   610  0.0032 :c0261df8:       lea    0x0(,%edx,4),%eax
               :c0261dff:       mov    %eax,-0x20(%ebp)
  3672  0.0191 :c0261e02:       jmp    c0261e13 <ring_buffer_consume+0x33>
               :c0261e04:       lea    0x0(%esi,%eiz,1),%esi
               :c0261e08:       test   %esi,%esi
               :c0261e0a:       je     c0261e68 <ring_buffer_consume+0x88>
  3367  0.0175 :c0261e0c:       testb  $0x3,(%esi)
    37 1.9e-04 :c0261e0f:       jne    c0261e68 <ring_buffer_consume+0x88>
               :c0261e11:       pause
  3410  0.0177 :c0261e13:       bt     %ebx,(%edi)
  7766  0.0404 :c0261e16:       sbb    %eax,%eax
  4221  0.0219 :c0261e18:       test   %eax,%eax
               :c0261e1a:       je     c0261e08 <ring_buffer_consume+0x28>
   940  0.0049 :c0261e1c:       mov    -0x18(%ebp),%edx
  2967  0.0154 :c0261e1f:       mov    0x28(%edx),%eax
 12178  0.0633 :c0261e22:       mov    -0x20(%ebp),%edx
  2547  0.0132 :c0261e25:       mov    (%eax,%edx,1),%eax
  5736  0.0298 :c0261e28:       mov    %eax,-0x14(%ebp)
  1065  0.0055 :c0261e2b:       add    $0x8,%eax
 27718  0.1440 :c0261e2e:       mov    %eax,-0x10(%ebp)
  4312  0.0224 :c0261e31:       call   c04d23b0 <_spin_lock_irqsave>
183800  0.9551 :c0261e36:       mov    -0x24(%ebp),%ecx
  3613  0.0188 :c0261e39:       mov    %eax,-0x1c(%ebp)
  6656  0.0346 :c0261e3c:       mov    %ebx,%edx
               :c0261e3e:       mov    -0x18(%ebp),%eax
    11 5.7e-05 :c0261e41:       call   c0261cf0 <rb_buffer_peek>
  3506  0.0182 :c0261e46:       mov    %eax,%esi
     2 1.0e-05 :c0261e48:       test   %eax,%eax
     2 1.0e-05 :c0261e4a:       je     c0261e54 <ring_buffer_consume+0x74>
     2 1.0e-05 :c0261e4c:       mov    -0x14(%ebp),%eax
    10 5.2e-05 :c0261e4f:       call   c0261580 <rb_advance_reader>
  3389  0.0176 :c0261e54:       mov    -0x1c(%ebp),%edx
    13 6.8e-05 :c0261e57:       mov    -0x10(%ebp),%eax
    17 8.8e-05 :c0261e5a:       call   c04d2500 <_spin_unlock_irqrestore>
 71541  0.3718 :c0261e5f:       test   %esi,%esi
     4 2.1e-05 :c0261e61:       jne    c0261e0c <ring_buffer_consume+0x2c>
               :c0261e63:       nop
               :c0261e64:       lea    0x0(%esi,%eiz,1),%esi
  3419  0.0178 :c0261e68:       add    $0x18,%esp
    11 5.7e-05 :c0261e6b:       mov    %esi,%eax
     1 5.2e-06 :c0261e6d:       pop    %ebx
  3403  0.0177 :c0261e6e:       pop    %esi
    17 8.8e-05 :c0261e6f:       pop    %edi
  3343  0.0174 :c0261e70:       leave
  3348  0.0174 :c0261e71:       ret

