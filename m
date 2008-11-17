Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKQU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKQU4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKQU4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:56:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYKQU4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:56:04 -0500
Date: Mon, 17 Nov 2008 21:55:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: skb_release_head_state(): Re: [Bug #11308] tbench regression on
	each kernel release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117205530.GE12020@elte.hu>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117184951.GA5585@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 100.000000 total
> ................
>   2.118525 skb_release_head_state

                      hits (total: 211852)
                 .........
ffffffff8048938e:      967 <skb_release_head_state>:
ffffffff8048938e:      967 	53                   	push   %rbx
ffffffff8048938f:     3975 	48 89 fb             	mov    %rdi,%rbx
ffffffff80489392:       17 	48 8b 7f 28          	mov    0x28(%rdi),%rdi
ffffffff80489396:        0 	e8 9c 93 00 00       	callq  ffffffff80492737 <dst_release>
ffffffff8048939b:        6 	48 8b 7b 30          	mov    0x30(%rbx),%rdi
ffffffff8048939f:     2887 	48 85 ff             	test   %rdi,%rdi
ffffffff804893a2:      859 	74 0f                	je     ffffffff804893b3 <skb_release_head_state+0x25>
ffffffff804893a4:        0 	f0 ff 0f             	lock decl (%rdi)
ffffffff804893a7:        0 	0f 94 c0             	sete   %al
ffffffff804893aa:        0 	84 c0                	test   %al,%al
ffffffff804893ac:        0 	74 05                	je     ffffffff804893b3 <skb_release_head_state+0x25>
ffffffff804893ae:        0 	e8 7a 14 06 00       	callq  ffffffff804ea82d <__secpath_destroy>
ffffffff804893b3:       16 	48 83 bb 80 00 00 00 	cmpq   $0x0,0x80(%rbx)
ffffffff804893ba:        0 	00 
ffffffff804893bb:     4294 	74 31                	je     ffffffff804893ee <skb_release_head_state+0x60>
ffffffff804893bd:        0 	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
ffffffff804893c4:        0 	00 00 
ffffffff804893c6:     6540 	48 63 80 48 e0 ff ff 	movslq -0x1fb8(%rax),%rax
ffffffff804893cd:       14 	a9 00 00 ff 0f       	test   $0xfff0000,%eax
ffffffff804893d2:      471 	74 11                	je     ffffffff804893e5 <skb_release_head_state+0x57>
ffffffff804893d4:        0 	be 89 01 00 00       	mov    $0x189,%esi
ffffffff804893d9:        0 	48 c7 c7 cc b1 6a 80 	mov    $0xffffffff806ab1cc,%rdi
ffffffff804893e0:        0 	e8 d0 cd da ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804893e5:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804893e8:     1733 	ff 93 80 00 00 00    	callq  *0x80(%rbx)
ffffffff804893ee:      888 	48 8b bb 88 00 00 00 	mov    0x88(%rbx),%rdi
ffffffff804893f5:     3959 	48 85 ff             	test   %rdi,%rdi
ffffffff804893f8:        0 	74 0f                	je     ffffffff80489409 <skb_release_head_state+0x7b>
ffffffff804893fa:        0 	f0 ff 0f             	lock decl (%rdi)
ffffffff804893fd:        0 	0f 94 c0             	sete   %al
ffffffff80489400:        0 	84 c0                	test   %al,%al
ffffffff80489402:        0 	74 05                	je     ffffffff80489409 <skb_release_head_state+0x7b>
ffffffff80489404:        0 	e8 48 f2 01 00       	callq  ffffffff804a8651 <nf_conntrack_destroy>
ffffffff80489409:        0 	48 8b bb 90 00 00 00 	mov    0x90(%rbx),%rdi
ffffffff80489410:     3132 	48 85 ff             	test   %rdi,%rdi
ffffffff80489413:        1 	74 05                	je     ffffffff8048941a <skb_release_head_state+0x8c>
ffffffff80489415:        0 	e8 d7 f7 ff ff       	callq  ffffffff80488bf1 <kfree_skb>
ffffffff8048941a:      958 	48 8b bb 98 00 00 00 	mov    0x98(%rbx),%rdi
ffffffff80489421:     1999 	48 85 ff             	test   %rdi,%rdi
ffffffff80489424:        0 	74 0f                	je     ffffffff80489435 <skb_release_head_state+0xa7>
ffffffff80489426:        0 	f0 ff 0f             	lock decl (%rdi)
ffffffff80489429:        0 	0f 94 c0             	sete   %al
ffffffff8048942c:        0 	84 c0                	test   %al,%al
ffffffff8048942e:        0 	74 05                	je     ffffffff80489435 <skb_release_head_state+0xa7>
ffffffff80489430:        0 	e8 a7 5f e0 ff       	callq  ffffffff8028f3dc <kfree>
ffffffff80489435:        0 	66 c7 83 a6 00 00 00 	movw   $0x0,0xa6(%rbx)
ffffffff8048943c:        0 	00 00 
ffffffff8048943e:     6503 	66 c7 83 a8 00 00 00 	movw   $0x0,0xa8(%rbx)
ffffffff80489445:        0 	00 00 
ffffffff80489447:   174101 	5b                   	pop    %rbx
ffffffff80489448:        0 	c3                   	retq   

this function _really_ hurts from a 16-bit op:

ffffffff8048943e:     6503 	66 c7 83 a8 00 00 00 	movw   $0x0,0xa8(%rbx)
ffffffff80489445:        0 	00 00 
ffffffff80489447:   174101 	5b                   	pop    %rbx

(gdb) list *0xffffffff8048943e
0xffffffff8048943e is in skb_release_head_state 
(net/core/skbuff.c:407).
402	#endif
403	/* XXX: IS this still necessary? - JHS */
404	#ifdef CONFIG_NET_SCHED
405		skb->tc_index = 0;
406	#ifdef CONFIG_NET_CLS_ACT
407		skb->tc_verd = 0;
408	#endif
409	#endif
410	}
411	

dirtying skb->tc_verd. I do have:

CONFIG_NET_CLS_ACT=y

BUT, on a second look, i dont think it's really this 16-bit op that 
hurts us. The wider context is:

ffffffff80489426:        0 	f0 ff 0f             	lock decl (%rdi)
ffffffff80489429:        0 	0f 94 c0             	sete   %al
ffffffff8048942c:        0 	84 c0                	test   %al,%al
ffffffff8048942e:        0 	74 05                	je     ffffffff80489435 <skb_release_head_state+0xa7>
ffffffff80489430:        0 	e8 a7 5f e0 ff       	callq  ffffffff8028f3dc <kfree>
ffffffff80489435:        0 	66 c7 83 a6 00 00 00 	movw   $0x0,0xa6(%rbx)
ffffffff8048943c:        0 	00 00 
ffffffff8048943e:     6503 	66 c7 83 a8 00 00 00 	movw   $0x0,0xa8(%rbx)
ffffffff80489445:        0 	00 00 
ffffffff80489447:   174101 	5b                   	pop    %rbx
ffffffff80489448:        0 	c3                   	retq   

look how we jump over the callq most of the time - so what we are 
seeing here i believe is the cost of the atomic op at 
ffffffff80489426. That comes from:

(gdb) list *0xffffffff8048942e
0xffffffff8048942e is in skb_release_head_state (include/linux/skbuff.h:1783).
1778	}
1779	#endif
1780	#ifdef CONFIG_BRIDGE_NETFILTER
1781	static inline void nf_bridge_put(struct nf_bridge_info *nf_bridge)
1782	{
1783		if (nf_bridge && atomic_dec_and_test(&nf_bridge->use))
1784			kfree(nf_bridge);
1785	}
1786	static inline void nf_bridge_get(struct nf_bridge_info *nf_bridge)
1787	{

and ouch does that global dec on &nf_bridge->use hurt!

i do have:

  CONFIG_BRIDGE_NETFILTER=y

(this is a Fedora distro kernel derived .config)

	Ingo
