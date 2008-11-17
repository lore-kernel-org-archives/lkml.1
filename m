Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYKQU4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYKQU4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKQU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:56:43 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:41253 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKQU4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:56:42 -0500
Message-ID: <4921DA76.9050206@cosmosbay.com>
Date: Mon, 17 Nov 2008 21:56:22 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117204743.GD12020@elte.hu>
In-Reply-To: <20081117204743.GD12020@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 21:56:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> 100.000000 total
>> ................
>>   3.038025 skb_release_data
> 
>                       hits (303802 total)
>                  .........
> ffffffff80488c7e:      780 <skb_release_data>:
> ffffffff80488c7e:      780 	55                   	push   %rbp
> ffffffff80488c7f:   267141 	53                   	push   %rbx
> ffffffff80488c80:        0 	48 89 fb             	mov    %rdi,%rbx
> ffffffff80488c83:     3552 	48 83 ec 08          	sub    $0x8,%rsp
> ffffffff80488c87:      604 	8a 47 7c             	mov    0x7c(%rdi),%al
> ffffffff80488c8a:     2644 	a8 02                	test   $0x2,%al
> ffffffff80488c8c:       49 	74 2a                	je     ffffffff80488cb8 <skb_release_data+0x3a>
> ffffffff80488c8e:        0 	83 e0 10             	and    $0x10,%eax
> ffffffff80488c91:     2079 	8b 97 c8 00 00 00    	mov    0xc8(%rdi),%edx
> ffffffff80488c97:       53 	3c 01                	cmp    $0x1,%al
> ffffffff80488c99:        0 	19 c0                	sbb    %eax,%eax
> ffffffff80488c9b:      870 	48 03 97 d0 00 00 00 	add    0xd0(%rdi),%rdx
> ffffffff80488ca2:       65 	66 31 c0             	xor    %ax,%ax
> ffffffff80488ca5:        0 	05 01 00 01 00       	add    $0x10001,%eax
> ffffffff80488caa:      888 	f7 d8                	neg    %eax
> ffffffff80488cac:       49 	89 c1                	mov    %eax,%ecx
> ffffffff80488cae:        0 	f0 0f c1 0a          	lock xadd %ecx,(%rdx)
> ffffffff80488cb2:     1909 	01 c8                	add    %ecx,%eax
> ffffffff80488cb4:     1040 	85 c0                	test   %eax,%eax
> ffffffff80488cb6:        0 	75 6d                	jne    ffffffff80488d25 <skb_release_data+0xa7>
> ffffffff80488cb8:        0 	8b 93 c8 00 00 00    	mov    0xc8(%rbx),%edx
> ffffffff80488cbe:     4199 	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
> ffffffff80488cc5:     4995 	31 ed                	xor    %ebp,%ebp
> ffffffff80488cc7:        0 	66 83 7c 10 04 00    	cmpw   $0x0,0x4(%rax,%rdx,1)
> ffffffff80488ccd:      983 	75 15                	jne    ffffffff80488ce4 <skb_release_data+0x66>
> ffffffff80488ccf:       15 	eb 28                	jmp    ffffffff80488cf9 <skb_release_data+0x7b>
> ffffffff80488cd1:      665 	48 63 c5             	movslq %ebp,%rax
> ffffffff80488cd4:      546 	ff c5                	inc    %ebp
> ffffffff80488cd6:      328 	48 c1 e0 04          	shl    $0x4,%rax
> ffffffff80488cda:      356 	48 8b 7c 02 20       	mov    0x20(%rdx,%rax,1),%rdi
> ffffffff80488cdf:       95 	e8 be 87 de ff       	callq  ffffffff802714a2 <put_page>
> ffffffff80488ce4:       66 	8b 93 c8 00 00 00    	mov    0xc8(%rbx),%edx
> ffffffff80488cea:     1321 	48 03 93 d0 00 00 00 	add    0xd0(%rbx),%rdx
> ffffffff80488cf1:      439 	0f b7 42 04          	movzwl 0x4(%rdx),%eax
> ffffffff80488cf5:        0 	39 c5                	cmp    %eax,%ebp
> ffffffff80488cf7:     1887 	7c d8                	jl     ffffffff80488cd1 <skb_release_data+0x53>
> ffffffff80488cf9:     2187 	8b 93 c8 00 00 00    	mov    0xc8(%rbx),%edx
> ffffffff80488cff:     1784 	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
> ffffffff80488d06:      422 	48 83 7c 10 18 00    	cmpq   $0x0,0x18(%rax,%rdx,1)
> ffffffff80488d0c:      110 	74 08                	je     ffffffff80488d16 <skb_release_data+0x98>
> ffffffff80488d0e:        0 	48 89 df             	mov    %rbx,%rdi
> ffffffff80488d11:        0 	e8 52 ff ff ff       	callq  ffffffff80488c68 <skb_drop_fraglist>
> ffffffff80488d16:       14 	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
> ffffffff80488d1d:      715 	5e                   	pop    %rsi
> ffffffff80488d1e:      109 	5b                   	pop    %rbx
> ffffffff80488d1f:       20 	5d                   	pop    %rbp
> ffffffff80488d20:      980 	e9 b7 66 e0 ff       	jmpq   ffffffff8028f3dc <kfree>
> ffffffff80488d25:        0 	59                   	pop    %rcx
> ffffffff80488d26:     1948 	5b                   	pop    %rbx
> ffffffff80488d27:        0 	5d                   	pop    %rbp
> ffffffff80488d28:        0 	c3                   	retq   
> 
> this is a short function, and 90% of the overhead is false leaked-in 
> overhead from callsites:
> 
> ffffffff80488c7f:   267141 	53                   	push   %rbx
> 
> unfortunately i have a hard time mapping its callsites. 
> pskb_expand_head() is the only static callsite, but it's not active in 
> the profile.
> 
> The _usual_ callsite is normally skb_release_all(), which does have 
> overhead:
> 
> ffffffff80489449:      925 <skb_release_all>:
> ffffffff80489449:      925 	53                   	push   %rbx
> ffffffff8048944a:     5249 	48 89 fb             	mov    %rdi,%rbx
> ffffffff8048944d:        4 	e8 3c ff ff ff       	callq  ffffffff8048938e <skb_release_head_state>
> ffffffff80489452:     1149 	48 89 df             	mov    %rbx,%rdi
> ffffffff80489455:    13163 	5b                   	pop    %rbx
> ffffffff80489456:        0 	e9 23 f8 ff ff       	jmpq   ffffffff80488c7e <skb_release_data>
> 
> it is also tail-optimized, which explains why i found little 
> callsites. The main callsite of skb_release_all() is:
> 
> ffffffff80488b86:       26 	e8 be 08 00 00       	callq  ffffffff80489449 <skb_release_all>
> 
> which is __kfree_skb(). That is a frequently referenced function, and 
> in my profile there's a single callsite active:
> 
> ffffffff804c1027:      432 	e8 56 7b fc ff       	callq  ffffffff80488b82 <__kfree_skb>
> 
> which is tcp_ack() - subject of a later email. The wider context is:
> 
> ffffffff804c0ffc:      433 	41 2b 85 e0 00 00 00 	sub    0xe0(%r13),%eax
> ffffffff804c1003:     4843 	89 85 f0 00 00 00    	mov    %eax,0xf0(%rbp)
> ffffffff804c1009:     1730 	48 8b 45 30          	mov    0x30(%rbp),%rax
> ffffffff804c100d:      311 	41 8b 95 e0 00 00 00 	mov    0xe0(%r13),%edx
> ffffffff804c1014:        0 	48 83 b8 b0 00 00 00 	cmpq   $0x0,0xb0(%rax)
> ffffffff804c101b:        0 	00 
> ffffffff804c101c:      418 	74 06                	je     ffffffff804c1024 <tcp_ack+0x50d>
> ffffffff804c101e:       37 	01 95 f4 00 00 00    	add    %edx,0xf4(%rbp)
> ffffffff804c1024:        2 	4c 89 ef             	mov    %r13,%rdi
> ffffffff804c1027:      432 	e8 56 7b fc ff       	callq  ffffffff80488b82 <__kfree_skb>
> 
> this is a good, top-of-the-line x86 CPU with a really good BTB 
> implementation that seems to be able to fall through calls and tail 
> optimizations as if they werent there.
> 
> some guesses are:
> 
> (gdb) list *0xffffffff804c1003
> 0xffffffff804c1003 is in tcp_ack (include/net/sock.h:789).
> 784	
> 785	static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
> 786	{
> 787		skb_truesize_check(skb);
> 788		sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
> 789		sk->sk_wmem_queued -= skb->truesize;
> 790		sk_mem_uncharge(sk, skb->truesize);
> 791		__kfree_skb(skb);
> 792	}
> 793	
> 
> both sk and skb should be cache-hot here so this seems unlikely.
> 
> (gdb) list *0xffffffff804c10090xffffffff804c1009 is in tcp_ack (include/net/sock.h:736).
> 731	}
> 732	
> 733	static inline int sk_has_account(struct sock *sk)
> 734	{
> 735		/* return true if protocol supports memory accounting */
> 736		return !!sk->sk_prot->memory_allocated;
> 737	}
> 738	
> 739	static inline int sk_wmem_schedule(struct sock *sk, int size)
> 740	{
> 
> this cannot be it - unless sk_prot somehow ends up being dirtied or 
> false-shared?
> 
> Still, my guess would be on ffffffff804c1009 and a 
> sk_prot->memory_allocated cachemiss: look at how this instruction uses 
> %ebp, and the one that shows the many hits in skb_release_data() 
> pushes %ebp to the stack - that's where the CPU's OOO trick ends: it 
> has to compute the result and serialize on the cachemiss.
> 

I did some investigation on this part (memory_allocated) and discovered UDP had a problem,
not TCP (and tbench)

commit 270acefafeb74ce2fe93d35b75733870bf1e11e7

net: sk_free_datagram() should use sk_mem_reclaim_partial()

I noticed a contention on udp_memory_allocated on regular UDP applications.

While tcp_memory_allocated is seldom used, it appears each incoming UDP frame
is currently touching udp_memory_allocated when queued, and when received by
application.

One possible solution is to use sk_mem_reclaim_partial() instead of
sk_mem_reclaim(), so that we keep a small reserve (less than one page)
of memory for each UDP socket.

We did something very similar on TCP side in commit
9993e7d313e80bdc005d09c7def91903e0068f07
([TCP]: Do not purge sk_forward_alloc entirely in tcp_delack_timer())

A more complex solution would need to convert prot->memory_allocated to
use a percpu_counter with batches of 64 or 128 pages.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>


