Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYHVXkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYHVXkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 19:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYHVXjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 19:39:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:30563 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbYHVXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 19:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=MdzFlFmA6e3M4fAIOXLaDXMsO16mZN46799l66vnSvEgkDxqbGaPEKB3vqwKqIUfZ3
         QH6UESvbEWAnGBYgnVNkGbIzQJru9NbAElrzvU56yBPgYjftwgZOvEgneNI6jmGX63Dq
         BsU7A7o+Dixl/EOVV5K7p51DjL1TDL94umoLo=
Message-ID: <520f0cf10808221639k5c58dcc1p36e85f4da8f025d1@mail.gmail.com>
Date: Sat, 23 Aug 2008 01:39:50 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.26.3-rt3
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1219441175.22710.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_78536_1374777.1219448390656"
References: <1219441175.22710.22.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_78536_1374777.1219448390656
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Aug 22, 2008 at 11:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.26.3-rt3 tree, which can be
> downloaded from the location:
>
>  http://rt.et.redhat.com/download/
>
> Information on the RT patch can be found at:
>
>  http://rt.wiki.kernel.org/index.php/Main_Page
>
> Changes since 2.6.26-rt2
>
>  - patch merge fix (Steven Rostedt)
>
>  - fix net core sock locking (Chirag Jog)

Actually Peter Zijlstra. (Chirag was just first in the email thread)

>
>  - namespace lock fixes (Chirag Jog)
>
>  - hrtimers stuck in waitqueue fix (Thomas Gleixner)
>
>
> to build a 2.6.26.3-rt3 tree, the following patches should be applied:
>
>  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
>  http://rt.et.redhat.com/download/patch-2.6.26.3-rt3.bz2
>
>
>
> And like always, my RT version of Matt Mackall's ketchup will get this
> for you nicely:
>
>  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
>
>
> The broken out patches are also available.
>

One more patch that was missed - it was discussed here
http://marc.info/?l=linux-rt-users&m=121846031913931&w=2

I am resending it, please consider for -rt4.
Without it I continue to get the following type of message.

BUG: using smp_processor_id() in preemptible [00000000] code: firefox-bin/3912
caller is __qdisc_run+0x160/0x1e9
Pid: 3912, comm: firefox-bin Tainted: G        W 2.6.26.3-rt2 #6

Call Trace:
 [<ffffffff8033cc96>] debug_smp_processor_id+0xde/0xec
 [<ffffffff803f9a87>] __qdisc_run+0x160/0x1e9
 [<ffffffff803e8777>] dev_queue_xmit+0x1b3/0x2ee
 [<ffffffff8040df1e>] ip_finish_output+0x29b/0x2e4
 [<ffffffff8040e04a>] ip_output+0xe3/0xec
 [<ffffffff8040cf9c>] ip_local_out+0x25/0x29
 [<ffffffff8040d80e>] ip_queue_xmit+0x2ce/0x35e
 [<ffffffff804215a6>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff804215a6>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8027f844>] ? trace_preempt_on+0x1f/0xf9
 [<ffffffff8041e9de>] ? tcp_transmit_skb+0x72a/0x78f
 [<ffffffff804215a6>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8041ea04>] tcp_transmit_skb+0x750/0x78f
 [<ffffffff802ac050>] ? kmem_cache_alloc_node+0x11e/0x145
 [<ffffffff804215a6>] __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff803e2c55>] ? __alloc_skb+0x70/0x136
 [<ffffffff804158f1>] tcp_sendmsg+0x941/0xa5f
 [<ffffffff802c01f3>] ? __pollwait+0x0/0xe5
 [<ffffffff803dbd3e>] sock_sendmsg+0x102/0x125
 [<ffffffff8024c3b3>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff80281a97>] ? tracing_hist_preempt_stop+0x2cb/0x2f5
 [<ffffffff80272624>] ? __rcu_read_unlock+0x93/0xa7
 [<ffffffff802b250e>] ? fget_light+0x97/0xad
 [<ffffffff803dc8ee>] sys_sendto+0xe4/0x10c
 [<ffffffff8024c3b3>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8021251c>] ? native_sched_clock+0x2a/0x72
 [<ffffffff803dc92a>] sys_send+0x14/0x16
 [<ffffffff803f7dbb>] compat_sys_socketcall+0xd2/0x16c
 [<ffffffff80224a17>] sysenter_do_call+0x8c/0x149
 [<ffffffff8045f4ec>] ? trace_hardirqs_on_thunk+0x3a/0x3c

---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<ffffffff8033cc43>] .... debug_smp_processor_id+0x8b/0xec
.....[<ffffffff803f9a87>] ..   ( <= __qdisc_run+0x160/0x1e9)

BUG: firefox-bin:3912 task might have lost a preemption check!
Pid: 3912, comm: firefox-bin Tainted: G        W 2.6.26.3-rt2 #6

Call Trace:
 [<ffffffff80462e79>] ? sub_preempt_count+0xd1/0xe6
 [<ffffffff80233bb1>] preempt_enable_no_resched+0x5c/0x5e
 [<ffffffff8033cc9b>] debug_smp_processor_id+0xe3/0xec
 [<ffffffff803f9a87>] __qdisc_run+0x160/0x1e9
 [<ffffffff803e8777>] dev_queue_xmit+0x1b3/0x2ee
 [<ffffffff8040df1e>] ip_finish_output+0x29b/0x2e4
 [<ffffffff8040e04a>] ip_output+0xe3/0xec
 [<ffffffff8040cf9c>] ip_local_out+0x25/0x29
 [<ffffffff8040d80e>] ip_queue_xmit+0x2ce/0x35e
 [<ffffffff804215a6>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff804215a6>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8027f844>] ? trace_preempt_on+0x1f/0xf9
 [<ffffffff8041e9de>] ? tcp_transmit_skb+0x72a/0x78f
 [<ffffffff804215a6>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8041ea04>] tcp_transmit_skb+0x750/0x78f
 [<ffffffff802ac050>] ? kmem_cache_alloc_node+0x11e/0x145
 [<ffffffff804215a6>] __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff803e2c55>] ? __alloc_skb+0x70/0x136
 [<ffffffff804158f1>] tcp_sendmsg+0x941/0xa5f
 [<ffffffff802c01f3>] ? __pollwait+0x0/0xe5
 [<ffffffff803dbd3e>] sock_sendmsg+0x102/0x125
 [<ffffffff8024c3b3>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff80281a97>] ? tracing_hist_preempt_stop+0x2cb/0x2f5
 [<ffffffff80272624>] ? __rcu_read_unlock+0x93/0xa7
 [<ffffffff802b250e>] ? fget_light+0x97/0xad
 [<ffffffff803dc8ee>] sys_sendto+0xe4/0x10c
 [<ffffffff8024c3b3>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8021251c>] ? native_sched_clock+0x2a/0x72
 [<ffffffff803dc92a>] sys_send+0x14/0x16
 [<ffffffff803f7dbb>] compat_sys_socketcall+0xd2/0x16c
 [<ffffffff80224a17>] sysenter_do_call+0x8c/0x149
 [<ffffffff8045f4ec>] ? trace_hardirqs_on_thunk+0x3a/0x3c

---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------


Thank You.

------=_Part_78536_1374777.1219448390656
Content-Type: text/x-patch; name=qdisc_run.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk7fzc2i0
Content-Disposition: attachment; filename=qdisc_run.patch

U3ViamVjdDogZml4IGZvciBCVUc6IHVzaW5nIHNtcF9wcm9jZXNzb3JfaWQoKSBpbiBwcmVlbXB0
aWJsZSBjb2RlCgpGaXhlcyB1c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUg
Y29kZSBhcyBzZWVuIHdoZW4gX19xZGlzY19ydW4KY2FsbHMgcWRpc2NfcmVzdGFydCB3aGljaCBj
YWxscyBoYW5kbGVfZGV2X2NwdV9jb2xsaXNpb24KClRoaXMgaXMgZml4ZWQgYnkgZGlzYWJsaW5n
IGlycXMgKGFuZCBwcmVlbXB0aW9uKSBhcm91bmQgY3B1X2NvbGxpc2lvbisrCmluIGhhbmRsZV9k
ZXZfY3B1X2NvbGxpc2lvbgoKU2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyIGF0IGdt
YWlsIGRvdCBjb20+CgpJbmRleDogbGludXgtMi42LjI2LjEtcnQxLmprL25ldC9zY2hlZC9zY2hf
Z2VuZXJpYy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yNi4xLXJ0MS5qay5vcmlnL25ldC9z
Y2hlZC9zY2hfZ2VuZXJpYy5jCisrKyBsaW51eC0yLjYuMjYuMS1ydDEuamsvbmV0L3NjaGVkL3Nj
aF9nZW5lcmljLmMKQEAgLTk0LDYgKzk0LDcgQEAgc3RhdGljIGlubGluZSBpbnQgaGFuZGxlX2Rl
dl9jcHVfY29sbGlzaQogCQkJCQkgICBzdHJ1Y3QgUWRpc2MgKnEpCiB7CiAJaW50IHJldDsKKwl1
bnNpZ25lZCBsb25nIGZsYWdzOwogCiAJaWYgKHVubGlrZWx5KGRldi0+eG1pdF9sb2NrX293bmVy
ID09ICh2b2lkICopY3VycmVudCkpIHsKIAkJLyoKQEAgLTExMiw3ICsxMTMsOSBAQCBzdGF0aWMg
aW5saW5lIGludCBoYW5kbGVfZGV2X2NwdV9jb2xsaXNpCiAJCSAqIEFub3RoZXIgY3B1IGlzIGhv
bGRpbmcgbG9jaywgcmVxdWV1ZSAmIGRlbGF5IHhtaXRzIGZvcgogCQkgKiBzb21lIHRpbWUuCiAJ
CSAqLworCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7CiAJCV9fZ2V0X2NwdV92YXIobmV0ZGV2X3J4
X3N0YXQpLmNwdV9jb2xsaXNpb24rKzsKKwkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwogCQly
ZXQgPSBkZXZfcmVxdWV1ZV9za2Ioc2tiLCBkZXYsIHEpOwogCX0KIAo=
------=_Part_78536_1374777.1219448390656--
