Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYKQWPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYKQWPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYKQWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:15:34 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54976 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYKQWPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:15:32 -0500
Message-ID: <4921ECB5.6050503@cosmosbay.com>
Date: Mon, 17 Nov 2008 23:14:13 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: __inet_lookup_established(): Re: [Bug #11308] tbench regression
 on	each kernel release from 2.6.22 -&gt; 2.6.28
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117213520.GI12020@elte.hu>
In-Reply-To: <20081117213520.GI12020@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 23:14:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> 100.000000 total
>> ................
>>   1.673249 __inet_lookup_established
> 
>                       hits (total: 167324)
>                  .........
> ffffffff804b9b12:      446 <__inet_lookup_established>:
> ffffffff804b9b12:      446 	41 57                	push   %r15
> ffffffff804b9b14:     4810 	89 d0                	mov    %edx,%eax
> ffffffff804b9b16:        0 	0f b7 c9             	movzwl %cx,%ecx
> ffffffff804b9b19:        0 	41 56                	push   %r14
> ffffffff804b9b1b:      456 	41 55                	push   %r13
> ffffffff804b9b1d:        0 	41 54                	push   %r12
> ffffffff804b9b1f:        0 	55                   	push   %rbp
> ffffffff804b9b20:      427 	53                   	push   %rbx
> ffffffff804b9b21:        4 	48 89 f3             	mov    %rsi,%rbx
> ffffffff804b9b24:        2 	44 89 c6             	mov    %r8d,%esi
> ffffffff804b9b27:      504 	41 89 c8             	mov    %ecx,%r8d
> ffffffff804b9b2a:        1 	49 89 f7             	mov    %rsi,%r15
> ffffffff804b9b2d:        1 	48 83 ec 08          	sub    $0x8,%rsp
> ffffffff804b9b31:      462 	49 c1 e7 20          	shl    $0x20,%r15
> ffffffff804b9b35:        0 	48 89 3c 24          	mov    %rdi,(%rsp)
> ffffffff804b9b39:      507 	89 d7                	mov    %edx,%edi
> ffffffff804b9b3b:       38 	41 0f b7 d1          	movzwl %r9w,%edx
> ffffffff804b9b3f:        0 	41 89 d6             	mov    %edx,%r14d
> ffffffff804b9b42:      863 	49 09 c7             	or     %rax,%r15
> ffffffff804b9b45:       24 	41 c1 e6 10          	shl    $0x10,%r14d
> ffffffff804b9b49:        0 	41 09 ce             	or     %ecx,%r14d
> ffffffff804b9b4c:      479 	89 f9                	mov    %edi,%ecx
> ffffffff804b9b4e:        8 	48 8b 3c 24          	mov    (%rsp),%rdi
> ffffffff804b9b52:        0 	e8 cc f4 ff ff       	callq  ffffffff804b9023 <inet_ehashfn>
> ffffffff804b9b57:      413 	48 89 df             	mov    %rbx,%rdi
> ffffffff804b9b5a:      122 	41 89 c5             	mov    %eax,%r13d
> ffffffff804b9b5d:        0 	89 c6                	mov    %eax,%esi
> ffffffff804b9b5f:      635 	e8 3e f5 ff ff       	callq  ffffffff804b90a2 <inet_ehash_bucket>
> ffffffff804b9b64:      511 	48 89 c5             	mov    %rax,%rbp
> ffffffff804b9b67:        6 	44 89 e8             	mov    %r13d,%eax
> ffffffff804b9b6a:        0 	23 43 14             	and    0x14(%rbx),%eax
> ffffffff804b9b6d:      497 	4c 8d 24 85 00 00 00 	lea    0x0(,%rax,4),%r12
> ffffffff804b9b74:        0 	00 
> ffffffff804b9b75:        1 	4c 03 63 08          	add    0x8(%rbx),%r12
> ffffffff804b9b79:        0 	48 8b 45 00          	mov    0x0(%rbp),%rax
> ffffffff804b9b7d:      470 	0f 18 08             	prefetcht0 (%rax)
> ffffffff804b9b80:        0 	4c 89 e7             	mov    %r12,%rdi
> ffffffff804b9b83:     1089 	e8 32 cd 05 00       	callq  ffffffff805168ba <_read_lock>
> ffffffff804b9b88:     6752 	48 8b 55 00          	mov    0x0(%rbp),%rdx
> ffffffff804b9b8c:      598 	eb 2c                	jmp    ffffffff804b9bba <__inet_lookup_established+0xa8>
> ffffffff804b9b8e:      447 	48 81 3c 24 d0 15 ab 	cmpq   $0xffffffff80ab15d0,(%rsp)
> ffffffff804b9b95:        0 	80 
> ffffffff804b9b96:     1119 	75 1f                	jne    ffffffff804b9bb7 <__inet_lookup_established+0xa5>
> ffffffff804b9b98:       21 	4c 39 b8 30 02 00 00 	cmp    %r15,0x230(%rax)
> ffffffff804b9b9f:        0 	75 16                	jne    ffffffff804b9bb7 <__inet_lookup_established+0xa5>
> ffffffff804b9ba1:      492 	44 39 b0 38 02 00 00 	cmp    %r14d,0x238(%rax)
> ffffffff804b9ba8:        0 	75 0d                	jne    ffffffff804b9bb7 <__inet_lookup_established+0xa5>
> ffffffff804b9baa:        0 	8b 52 fc             	mov    -0x4(%rdx),%edx
> ffffffff804b9bad:      451 	85 d2                	test   %edx,%edx
> ffffffff804b9baf:        0 	74 67                	je     ffffffff804b9c18 <__inet_lookup_established+0x106>
> ffffffff804b9bb1:        0 	3b 54 24 40          	cmp    0x40(%rsp),%edx
> ffffffff804b9bb5:        0 	74 61                	je     ffffffff804b9c18 <__inet_lookup_established+0x106>
> ffffffff804b9bb7:        0 	48 89 ca             	mov    %rcx,%rdx
> ffffffff804b9bba:      402 	48 85 d2             	test   %rdx,%rdx
> ffffffff804b9bbd:     1006 	74 12                	je     ffffffff804b9bd1 <__inet_lookup_established+0xbf>
> ffffffff804b9bbf:        0 	48 8d 42 f8          	lea    -0x8(%rdx),%rax
> ffffffff804b9bc3:      821 	48 8b 0a             	mov    (%rdx),%rcx
> ffffffff804b9bc6:       78 	44 39 68 2c          	cmp    %r13d,0x2c(%rax)
> ffffffff804b9bca:        4 	0f 18 09             	prefetcht0 (%rcx)
> ffffffff804b9bcd:      685 	75 e8                	jne    ffffffff804b9bb7 <__inet_lookup_established+0xa5>
> ffffffff804b9bcf:   139502 	eb bd                	jmp    ffffffff804b9b8e <__inet_lookup_established+0x7c>
> ffffffff804b9bd1:        0 	48 8b 55 08          	mov    0x8(%rbp),%rdx
> ffffffff804b9bd5:        0 	eb 26                	jmp    ffffffff804b9bfd <__inet_lookup_established+0xeb>
> ffffffff804b9bd7:        0 	48 81 3c 24 d0 15 ab 	cmpq   $0xffffffff80ab15d0,(%rsp)
> ffffffff804b9bde:        0 	80 
> ffffffff804b9bdf:        0 	75 19                	jne    ffffffff804b9bfa <__inet_lookup_established+0xe8>
> ffffffff804b9be1:        0 	4c 39 78 40          	cmp    %r15,0x40(%rax)
> ffffffff804b9be5:        0 	75 13                	jne    ffffffff804b9bfa <__inet_lookup_established+0xe8>
> ffffffff804b9be7:        0 	44 39 70 48          	cmp    %r14d,0x48(%rax)
> ffffffff804b9beb:        0 	75 0d                	jne    ffffffff804b9bfa <__inet_lookup_established+0xe8>
> ffffffff804b9bed:        0 	8b 52 fc             	mov    -0x4(%rdx),%edx
> ffffffff804b9bf0:        0 	85 d2                	test   %edx,%edx
> ffffffff804b9bf2:        0 	74 24                	je     ffffffff804b9c18 <__inet_lookup_established+0x106>
> ffffffff804b9bf4:        0 	3b 54 24 40          	cmp    0x40(%rsp),%edx
> ffffffff804b9bf8:        0 	74 1e                	je     ffffffff804b9c18 <__inet_lookup_established+0x106>
> ffffffff804b9bfa:        0 	48 89 ca             	mov    %rcx,%rdx
> ffffffff804b9bfd:        0 	48 85 d2             	test   %rdx,%rdx
> ffffffff804b9c00:        0 	74 12                	je     ffffffff804b9c14 <__inet_lookup_established+0x102>
> ffffffff804b9c02:        0 	48 8d 42 f8          	lea    -0x8(%rdx),%rax
> ffffffff804b9c06:        0 	48 8b 0a             	mov    (%rdx),%rcx
> ffffffff804b9c09:        0 	44 39 68 2c          	cmp    %r13d,0x2c(%rax)
> ffffffff804b9c0d:        0 	0f 18 09             	prefetcht0 (%rcx)
> ffffffff804b9c10:        0 	75 e8                	jne    ffffffff804b9bfa <__inet_lookup_established+0xe8>
> ffffffff804b9c12:        0 	eb c3                	jmp    ffffffff804b9bd7 <__inet_lookup_established+0xc5>
> ffffffff804b9c14:        0 	31 c0                	xor    %eax,%eax
> ffffffff804b9c16:        0 	eb 04                	jmp    ffffffff804b9c1c <__inet_lookup_established+0x10a>
> ffffffff804b9c18:      441 	f0 ff 40 28          	lock incl 0x28(%rax)
> ffffffff804b9c1c:     1442 	f0 41 ff 04 24       	lock incl (%r12)
> ffffffff804b9c21:      476 	41 5b                	pop    %r11
> ffffffff804b9c23:        1 	5b                   	pop    %rbx
> ffffffff804b9c24:        0 	5d                   	pop    %rbp
> ffffffff804b9c25:      475 	41 5c                	pop    %r12
> ffffffff804b9c27:        0 	41 5d                	pop    %r13
> ffffffff804b9c29:        1 	41 5e                	pop    %r14
> ffffffff804b9c2b:      494 	41 5f                	pop    %r15
> ffffffff804b9c2d:        0 	c3                   	retq   
> ffffffff804b9c2e:        0 	90                   	nop    
> ffffffff804b9c2f:        0 	90                   	nop    
> 
> 80% of the overhead comes from cachemisses here:
> 
> ffffffff804b9bc6:       78 	44 39 68 2c          	cmp    %r13d,0x2c(%rax)
> ffffffff804b9bca:        4 	0f 18 09             	prefetcht0 (%rcx)
> ffffffff804b9bcd:      685 	75 e8                	jne    ffffffff804b9bb7 <__inet_lookup_established+0xa5>
> ffffffff804b9bcf:   139502 	eb bd                	jmp    ffffffff804b9b8e <__inet_lookup_established+0x7c>
> 
> corresponding to:
> 
> (gdb) list *0xffffffff804b9bc6
> 0xffffffff804b9bc6 is in __inet_lookup_established (net/ipv4/inet_hashtables.c:237).
> 232		rwlock_t *lock = inet_ehash_lockp(hashinfo, hash);
> 233	
> 234		prefetch(head->chain.first);
> 235		read_lock(lock);
> 236		sk_for_each(sk, node, &head->chain) {
> 237			if (INET_MATCH(sk, net, hash, acookie,
> 238						saddr, daddr, ports, dif))
> 239				goto hit; /* You sunk my battleship! */
> 240		}
> 241	
> 
> Seeing the first hard cachemiss on hash lookups is a familiar and 
> partly expected pattern - it is the first thing that touches 
> cache-cold data structures.
> 
> Seeing 1.4% of the totaly tbench overhead go into this single 
> cachemiss is a bit surprising to me though: tbench works via 
> long-lived connections (TCP establish costs and nowhere to be seen in 
> the profiles) so the socket hash should be relatively stable and 
> read-mostly on most CPUs in theory. The CPUs here have 2MB of L2 cache 
> per socket.
> 
> Could we be somehow dirtying these cachelines perhaps, causing 
> unnecessary cachemisses in hash lookups? Is the hash linkage portion 
> of the socket data structure frequently dirtied? Padding that to 64 
> bytes (or next to 64 bytes worth of read-mostly fields) could perhaps 
> give us a +1.7% tbench speedup.
> 

I am not seeing this of course on net-next-2.6 thanks to RCU

Could it be that several tbench sockets are hashed on same chain ?

tbench uses dst address and src address 127.0.0.1 for its sockets.
server binds on port 7003


static inline unsigned int inet_ehashfn(struct net *net,
                                        const __be32 laddr, const __u16 lport,
                                        const __be32 faddr, const __be16 fport)
{
        return jhash_3words((__force __u32) laddr,
                            (__force __u32) faddr,
                            ((__u32) lport) << 16 | (__force __u32)fport,
                            inet_ehash_secret + net_hash_mix(net));
}

Hum... should be OK, thanks to jhash.

Maybe same problem than eth_type_trans :

You have a cache line miss because the socket we handle in the chain was previously
handled by another cpu. (sk->refcnt being dirtied by this other cpu)


ffffffff804b9bc6:       78 	44 39 68 2c          	cmp    %r13d,0x2c(%rax)
ffffffff804b9bca:        4 	0f 18 09             	prefetcht0 (%rcx)

ffffffff804b9bcd:      685 	75 e8                	jne    ffffffff804b9bb7 <__inet_lookup_established+0xa5>
< "jne" stalls beccause CPU must bring to its cache 0x2c(%rax) to perform compare >

ffffffff804b9bcf:   139502 	eb bd                	jmp    ffffffff804b9b8e <__inet_lookup_established+0x7c>

Even if you padd/move refcnt somewhere else in sk, you'll need to take a reference on it,
so it wont help very much.


