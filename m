Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYKQUVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYKQUVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYKQUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:20:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYKQUU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:20:56 -0500
Date: Mon, 17 Nov 2008 21:20:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: (avc_has_perm_noaudit()) Re: [Bug #11308] tbench regression on
	each kernel release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117202018.GB12020@elte.hu>
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
>   3.934833 avc_has_perm_noaudit

this one seems spread out:

                      hits (total: 393483 hits)
                 .........
ffffffff80312af3:     1426 <avc_has_perm_noaudit>:
ffffffff80312af3:     1426 	41 57                	push   %r15
ffffffff80312af5:     6124 	41 56                	push   %r14
ffffffff80312af7:        0 	41 55                	push   %r13
ffffffff80312af9:     1443 	41 89 f5             	mov    %esi,%r13d
ffffffff80312afc:     1577 	41 54                	push   %r12
ffffffff80312afe:        0 	41 89 fc             	mov    %edi,%r12d
ffffffff80312b01:     1310 	55                   	push   %rbp
ffffffff80312b02:     1531 	53                   	push   %rbx
ffffffff80312b03:        3 	48 83 ec 68          	sub    $0x68,%rsp
ffffffff80312b07:     2202 	85 c9                	test   %ecx,%ecx
ffffffff80312b09:        0 	89 4c 24 0c          	mov    %ecx,0xc(%rsp)
ffffffff80312b0d:      550 	44 89 44 24 08       	mov    %r8d,0x8(%rsp)
ffffffff80312b12:     1572 	4c 89 0c 24          	mov    %r9,(%rsp)
ffffffff80312b16:        0 	66 89 54 24 12       	mov    %dx,0x12(%rsp)
ffffffff80312b1b:      588 	75 04                	jne    ffffffff80312b21 <avc_has_perm_noaudit+0x2e>
ffffffff80312b1d:        0 	0f 0b                	ud2a   
ffffffff80312b1f:        0 	eb fe                	jmp    ffffffff80312b1f <avc_has_perm_noaudit+0x2c>
ffffffff80312b21:     1646 	0f b7 44 24 12       	movzwl 0x12(%rsp),%eax
ffffffff80312b26:      829 	48 c7 c2 d0 26 93 80 	mov    $0xffffffff809326d0,%rdx
ffffffff80312b2d:      589 	89 44 24 14          	mov    %eax,0x14(%rsp)
ffffffff80312b31:      698 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
ffffffff80312b38:        0 	00 
ffffffff80312b39:      791 	89 c0                	mov    %eax,%eax
ffffffff80312b3b:      549 	48 c1 e0 03          	shl    $0x3,%rax
ffffffff80312b3f:      791 	48 03 05 fa 30 5a 00 	add    0x5a30fa(%rip),%rax        # ffffffff808b5c40 <_cpu_pda>
ffffffff80312b46:      864 	48 8b 00             	mov    (%rax),%rax
ffffffff80312b49:      533 	48 03 50 08          	add    0x8(%rax),%rdx
ffffffff80312b4d:      732 	ff 02                	incl   (%rdx)
ffffffff80312b4f:      860 	8b 54 24 14          	mov    0x14(%rsp),%edx
ffffffff80312b53:     1259 	e8 54 fc ff ff       	callq  ffffffff803127ac <avc_hash>
ffffffff80312b58:     2087 	48 98                	cltq   
ffffffff80312b5a:     1015 	48 89 44 24 18       	mov    %rax,0x18(%rsp)
ffffffff80312b5f:        0 	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80312b63:     2944 	4c 8d b8 60 6b a9 80 	lea    -0x7f5694a0(%rax),%r15
ffffffff80312b6a:       71 	48 8b 80 60 6b a9 80 	mov    -0x7f5694a0(%rax),%rax
ffffffff80312b71:     3943 	eb 1a                	jmp    ffffffff80312b8d <avc_has_perm_noaudit+0x9a>
ffffffff80312b73:     5184 	44 3b 23             	cmp    (%rbx),%r12d
ffffffff80312b76:    62007 	75 11                	jne    ffffffff80312b89 <avc_has_perm_noaudit+0x96>
ffffffff80312b78:       11 	66 8b 44 24 12       	mov    0x12(%rsp),%ax
ffffffff80312b7d:        0 	66 3b 43 08          	cmp    0x8(%rbx),%ax
ffffffff80312b81:    11115 	75 06                	jne    ffffffff80312b89 <avc_has_perm_noaudit+0x96>
ffffffff80312b83:        4 	44 3b 6b 04          	cmp    0x4(%rbx),%r13d
ffffffff80312b87:    14224 	74 1a                	je     ffffffff80312ba3 <avc_has_perm_noaudit+0xb0>
ffffffff80312b89:        1 	48 8b 43 28          	mov    0x28(%rbx),%rax
ffffffff80312b8d:     6921 	48 8d 58 d8          	lea    -0x28(%rax),%rbx
ffffffff80312b91:     9654 	48 8b 43 28          	mov    0x28(%rbx),%rax
ffffffff80312b95:      414 	0f 18 08             	prefetcht0 (%rax)
ffffffff80312b98:      227 	48 8d 43 28          	lea    0x28(%rbx),%rax
ffffffff80312b9c:     9617 	4c 39 f8             	cmp    %r15,%rax
ffffffff80312b9f:     1402 	75 d2                	jne    ffffffff80312b73 <avc_has_perm_noaudit+0x80>
ffffffff80312ba1:        0 	eb 41                	jmp    ffffffff80312be4 <avc_has_perm_noaudit+0xf1>
ffffffff80312ba3:        0 	83 7b 20 01          	cmpl   $0x1,0x20(%rbx)
ffffffff80312ba7:      671 	0f 84 70 02 00 00    	je     ffffffff80312e1d <avc_has_perm_noaudit+0x32a>
ffffffff80312bad:        0 	c7 43 20 01 00 00 00 	movl   $0x1,0x20(%rbx)
ffffffff80312bb4:        0 	e9 64 02 00 00       	jmpq   ffffffff80312e1d <avc_has_perm_noaudit+0x32a>
ffffffff80312bb9:     2118 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff80312bc0:        0 	00 
ffffffff80312bc1:     8245 	89 d2                	mov    %edx,%edx
ffffffff80312bc3:        0 	48 c7 c0 d0 26 93 80 	mov    $0xffffffff809326d0,%rax
ffffffff80312bca:      511 	48 c1 e2 03          	shl    $0x3,%rdx
ffffffff80312bce:    11308 	48 03 15 6b 30 5a 00 	add    0x5a306b(%rip),%rdx        # ffffffff808b5c40 <_cpu_pda>
ffffffff80312bd5:        0 	48 8b 12             	mov    (%rdx),%rdx
ffffffff80312bd8:       35 	48 03 42 08          	add    0x8(%rdx),%rax
ffffffff80312bdc:     2224 	ff 40 04             	incl   0x4(%rax)
ffffffff80312bdf:        1 	e9 06 01 00 00       	jmpq   ffffffff80312cea <avc_has_perm_noaudit+0x1f7>
ffffffff80312be4:        0 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff80312beb:        0 	00 
ffffffff80312bec:        0 	89 d2                	mov    %edx,%edx
ffffffff80312bee:        0 	48 c7 c0 d0 26 93 80 	mov    $0xffffffff809326d0,%rax
ffffffff80312bf5:        0 	48 8d 6c 24 30       	lea    0x30(%rsp),%rbp
ffffffff80312bfa:        0 	48 c1 e2 03          	shl    $0x3,%rdx
ffffffff80312bfe:        0 	48 03 15 3b 30 5a 00 	add    0x5a303b(%rip),%rdx        # ffffffff808b5c40 <_cpu_pda>
ffffffff80312c05:        0 	44 89 ee             	mov    %r13d,%esi
ffffffff80312c08:        0 	4c 8d 45 0c          	lea    0xc(%rbp),%r8
ffffffff80312c0c:        0 	44 89 e7             	mov    %r12d,%edi
ffffffff80312c0f:        0 	48 8b 12             	mov    (%rdx),%rdx
ffffffff80312c12:        0 	48 03 42 08          	add    0x8(%rdx),%rax
ffffffff80312c16:        0 	ff 40 08             	incl   0x8(%rax)
ffffffff80312c19:        0 	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
ffffffff80312c1d:        0 	8b 54 24 14          	mov    0x14(%rsp),%edx
ffffffff80312c21:        0 	e8 ee 0a 01 00       	callq  ffffffff80323714 <security_compute_av>
ffffffff80312c26:        0 	85 c0                	test   %eax,%eax
ffffffff80312c28:        0 	41 89 c6             	mov    %eax,%r14d
ffffffff80312c2b:        0 	0f 85 02 02 00 00    	jne    ffffffff80312e33 <avc_has_perm_noaudit+0x340>
ffffffff80312c31:        0 	8b 7c 24 4c          	mov    0x4c(%rsp),%edi
ffffffff80312c35:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80312c3a:        0 	e8 a5 fb ff ff       	callq  ffffffff803127e4 <avc_latest_notif_update>
ffffffff80312c3f:        0 	85 c0                	test   %eax,%eax
ffffffff80312c41:        0 	0f 85 9c 00 00 00    	jne    ffffffff80312ce3 <avc_has_perm_noaudit+0x1f0>
ffffffff80312c47:        0 	e8 23 fd ff ff       	callq  ffffffff8031296f <avc_alloc_node>
ffffffff80312c4c:        0 	48 85 c0             	test   %rax,%rax
ffffffff80312c4f:        0 	48 89 c3             	mov    %rax,%rbx
ffffffff80312c52:        0 	0f 84 8b 00 00 00    	je     ffffffff80312ce3 <avc_has_perm_noaudit+0x1f0>
ffffffff80312c58:        0 	8b 4c 24 14          	mov    0x14(%rsp),%ecx
ffffffff80312c5c:        0 	49 89 e8             	mov    %rbp,%r8
ffffffff80312c5f:        0 	44 89 e6             	mov    %r12d,%esi
ffffffff80312c62:        0 	48 89 c7             	mov    %rax,%rdi
ffffffff80312c65:        0 	44 89 ea             	mov    %r13d,%edx
ffffffff80312c68:        0 	e8 5d fb ff ff       	callq  ffffffff803127ca <avc_node_populate>
ffffffff80312c6d:        0 	48 8b 44 24 18       	mov    0x18(%rsp),%rax
ffffffff80312c72:        0 	48 8d 2c 85 60 8b a9 	lea    -0x7f5674a0(,%rax,4),%rbp
ffffffff80312c79:        0 	80 
ffffffff80312c7a:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff80312c7d:        0 	e8 44 3c 20 00       	callq  ffffffff805168c6 <_spin_lock_irqsave>
ffffffff80312c82:        0 	49 8b 37             	mov    (%r15),%rsi
ffffffff80312c85:        0 	49 89 c6             	mov    %rax,%r14
ffffffff80312c88:        0 	eb 24                	jmp    ffffffff80312cae <avc_has_perm_noaudit+0x1bb>
ffffffff80312c8a:        0 	44 39 26             	cmp    %r12d,(%rsi)
ffffffff80312c8d:        0 	75 1b                	jne    ffffffff80312caa <avc_has_perm_noaudit+0x1b7>
ffffffff80312c8f:        0 	44 39 6e 04          	cmp    %r13d,0x4(%rsi)
ffffffff80312c93:        0 	75 15                	jne    ffffffff80312caa <avc_has_perm_noaudit+0x1b7>
ffffffff80312c95:        0 	66 8b 44 24 12       	mov    0x12(%rsp),%ax
ffffffff80312c9a:        0 	66 39 46 08          	cmp    %ax,0x8(%rsi)
ffffffff80312c9e:        0 	75 0a                	jne    ffffffff80312caa <avc_has_perm_noaudit+0x1b7>
ffffffff80312ca0:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff80312ca3:        0 	e8 9e fb ff ff       	callq  ffffffff80312846 <avc_node_replace>
ffffffff80312ca8:        0 	eb 2c                	jmp    ffffffff80312cd6 <avc_has_perm_noaudit+0x1e3>
ffffffff80312caa:        0 	48 8b 76 28          	mov    0x28(%rsi),%rsi
ffffffff80312cae:        0 	48 83 ee 28          	sub    $0x28,%rsi
ffffffff80312cb2:        0 	48 8b 56 28          	mov    0x28(%rsi),%rdx
ffffffff80312cb6:        0 	48 8d 46 28          	lea    0x28(%rsi),%rax
ffffffff80312cba:        0 	4c 39 f8             	cmp    %r15,%rax
ffffffff80312cbd:        0 	0f 18 0a             	prefetcht0 (%rdx)
ffffffff80312cc0:        0 	75 c8                	jne    ffffffff80312c8a <avc_has_perm_noaudit+0x197>
ffffffff80312cc2:        0 	48 8d 43 28          	lea    0x28(%rbx),%rax
ffffffff80312cc6:        0 	48 89 53 28          	mov    %rdx,0x28(%rbx)
ffffffff80312cca:        0 	4c 89 78 08          	mov    %r15,0x8(%rax)
ffffffff80312cce:        0 	48 89 46 28          	mov    %rax,0x28(%rsi)
ffffffff80312cd2:        0 	48 89 42 08          	mov    %rax,0x8(%rdx)
ffffffff80312cd6:        0 	4c 89 f6             	mov    %r14,%rsi
ffffffff80312cd9:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff80312cdc:        0 	e8 20 3d 20 00       	callq  ffffffff80516a01 <_spin_unlock_irqrestore>
ffffffff80312ce1:        0 	eb 07                	jmp    ffffffff80312cea <avc_has_perm_noaudit+0x1f7>
ffffffff80312ce3:        0 	48 8d 44 24 30       	lea    0x30(%rsp),%rax
ffffffff80312ce8:        0 	eb 06                	jmp    ffffffff80312cf0 <avc_has_perm_noaudit+0x1fd>
ffffffff80312cea:     2116 	48 89 d8             	mov    %rbx,%rax
ffffffff80312ced:     7632 	45 31 f6             	xor    %r14d,%r14d
ffffffff80312cf0:        1 	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
ffffffff80312cf5:      404 	74 10                	je     ffffffff80312d07 <avc_has_perm_noaudit+0x214>
ffffffff80312cf7:     1804 	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffffffff80312cfb:        0 	b9 05 00 00 00       	mov    $0x5,%ecx
ffffffff80312d00:      378 	48 8b 3c 24          	mov    (%rsp),%rdi
ffffffff80312d04:     8174 	fc                   	cld    
ffffffff80312d05:    26860 	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
ffffffff80312d07:    11573 	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff80312d0a:     1997 	f7 d0                	not    %eax
ffffffff80312d0c:        0 	85 44 24 0c          	test   %eax,0xc(%rsp)
ffffffff80312d10:        0 	0f 84 1d 01 00 00    	je     ffffffff80312e33 <avc_has_perm_noaudit+0x340>
ffffffff80312d16:        0 	f6 44 24 08 01       	testb  $0x1,0x8(%rsp)
ffffffff80312d1b:        0 	0f 85 f4 00 00 00    	jne    ffffffff80312e15 <avc_has_perm_noaudit+0x322>
ffffffff80312d21:        0 	83 3d 5c 66 78 00 00 	cmpl   $0x0,0x78665c(%rip)        # ffffffff80a99384 <selinux_enforcing>
ffffffff80312d28:        0 	74 10                	je     ffffffff80312d3a <avc_has_perm_noaudit+0x247>
ffffffff80312d2a:        0 	44 89 e7             	mov    %r12d,%edi
ffffffff80312d2d:        0 	e8 87 f9 00 00       	callq  ffffffff803226b9 <security_permissive_sid>
ffffffff80312d32:        0 	85 c0                	test   %eax,%eax
ffffffff80312d34:        0 	0f 84 db 00 00 00    	je     ffffffff80312e15 <avc_has_perm_noaudit+0x322>
ffffffff80312d3a:        0 	e8 30 fc ff ff       	callq  ffffffff8031296f <avc_alloc_node>
ffffffff80312d3f:        0 	48 85 c0             	test   %rax,%rax
ffffffff80312d42:        0 	48 89 c5             	mov    %rax,%rbp
ffffffff80312d45:        0 	0f 84 e8 00 00 00    	je     ffffffff80312e33 <avc_has_perm_noaudit+0x340>
ffffffff80312d4b:        0 	48 8b 44 24 18       	mov    0x18(%rsp),%rax
ffffffff80312d50:        0 	48 8d 04 85 60 8b a9 	lea    -0x7f5674a0(,%rax,4),%rax
ffffffff80312d57:        0 	80 
ffffffff80312d58:        0 	48 89 c7             	mov    %rax,%rdi
ffffffff80312d5b:        0 	48 89 44 24 28       	mov    %rax,0x28(%rsp)
ffffffff80312d60:        0 	e8 61 3b 20 00       	callq  ffffffff805168c6 <_spin_lock_irqsave>
ffffffff80312d65:        0 	49 8b 1f             	mov    (%r15),%rbx
ffffffff80312d68:        0 	48 89 44 24 20       	mov    %rax,0x20(%rsp)
ffffffff80312d6d:        0 	eb 1a                	jmp    ffffffff80312d89 <avc_has_perm_noaudit+0x296>
ffffffff80312d6f:        0 	44 3b 23             	cmp    (%rbx),%r12d
ffffffff80312d72:        0 	75 11                	jne    ffffffff80312d85 <avc_has_perm_noaudit+0x292>
ffffffff80312d74:        0 	44 3b 6b 04          	cmp    0x4(%rbx),%r13d
ffffffff80312d78:        0 	75 0b                	jne    ffffffff80312d85 <avc_has_perm_noaudit+0x292>
ffffffff80312d7a:        0 	66 8b 44 24 12       	mov    0x12(%rsp),%ax
ffffffff80312d7f:        0 	66 3b 43 08          	cmp    0x8(%rbx),%ax
ffffffff80312d83:        0 	74 1a                	je     ffffffff80312d9f <avc_has_perm_noaudit+0x2ac>
ffffffff80312d85:        0 	48 8b 5b 28          	mov    0x28(%rbx),%rbx
ffffffff80312d89:        0 	48 83 eb 28          	sub    $0x28,%rbx
ffffffff80312d8d:        0 	48 8b 43 28          	mov    0x28(%rbx),%rax
ffffffff80312d91:        0 	0f 18 08             	prefetcht0 (%rax)
ffffffff80312d94:        0 	48 8d 43 28          	lea    0x28(%rbx),%rax
ffffffff80312d98:        0 	4c 39 f8             	cmp    %r15,%rax
ffffffff80312d9b:        0 	75 d2                	jne    ffffffff80312d6f <avc_has_perm_noaudit+0x27c>
ffffffff80312d9d:        0 	eb 29                	jmp    ffffffff80312dc8 <avc_has_perm_noaudit+0x2d5>
ffffffff80312d9f:        0 	8b 4c 24 14          	mov    0x14(%rsp),%ecx
ffffffff80312da3:        0 	44 89 e6             	mov    %r12d,%esi
ffffffff80312da6:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff80312da9:        0 	49 89 d8             	mov    %rbx,%r8
ffffffff80312dac:        0 	44 89 ea             	mov    %r13d,%edx
ffffffff80312daf:        0 	e8 16 fa ff ff       	callq  ffffffff803127ca <avc_node_populate>
ffffffff80312db4:        0 	8b 44 24 0c          	mov    0xc(%rsp),%eax
ffffffff80312db8:        0 	09 45 0c             	or     %eax,0xc(%rbp)
ffffffff80312dbb:        0 	48 89 de             	mov    %rbx,%rsi
ffffffff80312dbe:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff80312dc1:        0 	e8 80 fa ff ff       	callq  ffffffff80312846 <avc_node_replace>
ffffffff80312dc6:        0 	eb 3c                	jmp    ffffffff80312e04 <avc_has_perm_noaudit+0x311>
ffffffff80312dc8:        0 	48 8b 3d a9 65 78 00 	mov    0x7865a9(%rip),%rdi        # ffffffff80a99378 <avc_node_cachep>
ffffffff80312dcf:        0 	48 89 ee             	mov    %rbp,%rsi
ffffffff80312dd2:        0 	e8 7b c6 f7 ff       	callq  ffffffff8028f452 <kmem_cache_free>
ffffffff80312dd7:        0 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
ffffffff80312dde:        0 	00 
ffffffff80312ddf:        0 	89 c0                	mov    %eax,%eax
ffffffff80312de1:        0 	48 c7 c2 d0 26 93 80 	mov    $0xffffffff809326d0,%rdx
ffffffff80312de8:        0 	48 c1 e0 03          	shl    $0x3,%rax
ffffffff80312dec:        0 	48 03 05 4d 2e 5a 00 	add    0x5a2e4d(%rip),%rax        # ffffffff808b5c40 <_cpu_pda>
ffffffff80312df3:        0 	48 8b 00             	mov    (%rax),%rax
ffffffff80312df6:        0 	48 03 50 08          	add    0x8(%rax),%rdx
ffffffff80312dfa:        0 	ff 42 14             	incl   0x14(%rdx)
ffffffff80312dfd:        0 	f0 ff 0d 60 65 78 00 	lock decl 0x786560(%rip)        # ffffffff80a99364 <avc_cache+0x2804>
ffffffff80312e04:        0 	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
ffffffff80312e09:        0 	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
ffffffff80312e0e:        0 	e8 ee 3b 20 00       	callq  ffffffff80516a01 <_spin_unlock_irqrestore>
ffffffff80312e13:        0 	eb 1e                	jmp    ffffffff80312e33 <avc_has_perm_noaudit+0x340>
ffffffff80312e15:        0 	41 be f3 ff ff ff    	mov    $0xfffffff3,%r14d
ffffffff80312e1b:        0 	eb 16                	jmp    ffffffff80312e33 <avc_has_perm_noaudit+0x340>
ffffffff80312e1d:    35502 	8b 44 24 0c          	mov    0xc(%rsp),%eax
ffffffff80312e21:     4360 	23 43 10             	and    0x10(%rbx),%eax
ffffffff80312e24:        0 	3b 44 24 0c          	cmp    0xc(%rsp),%eax
ffffffff80312e28:        0 	0f 85 b6 fd ff ff    	jne    ffffffff80312be4 <avc_has_perm_noaudit+0xf1>
ffffffff80312e2e:   104641 	e9 86 fd ff ff       	jmpq   ffffffff80312bb9 <avc_has_perm_noaudit+0xc6>
ffffffff80312e33:     2106 	48 83 c4 68          	add    $0x68,%rsp
ffffffff80312e37:        1 	44 89 f0             	mov    %r14d,%eax
ffffffff80312e3a:     2068 	5b                   	pop    %rbx
ffffffff80312e3b:        0 	5d                   	pop    %rbp
ffffffff80312e3c:        8 	41 5c                	pop    %r12
ffffffff80312e3e:     2001 	41 5d                	pop    %r13
ffffffff80312e40:        0 	41 5e                	pop    %r14
ffffffff80312e42:      162 	41 5f                	pop    %r15
ffffffff80312e44:     2107 	c3                   	retq   

its main callsite is:

  ffffffff8031368c:     2809 <avc_has_perm>:
  [...]
  ffffffff803136b6:      651 	e8 38 f4 ff ff       	callq  ffffffff80312af3 <avc_has_perm_noaudit>

avc_has_perm() usage is spread out amongst 3 callsites in 2 selinux 
functions:

selinux_ip_postroute():
  ffffffff80314d02:      491 	e8 85 e9 ff ff       	callq  ffffffff8031368c <avc_has_perm>

selinux_socket_sock_rcv_skb():
  ffffffff80314eea:      461 	e8 9d e7 ff ff       	callq  ffffffff8031368c <avc_has_perm>
  ffffffff80314faf:      476 	e8 d8 e6 ff ff       	callq  ffffffff8031368c <avc_has_perm>

related to networking.

regarding avc_has_perm_noaudit() itself, it has a couple of hot spots:

ffffffff80312b73:     5184 	44 3b 23             	cmp    (%rbx),%r12d
ffffffff80312b76:    62007 	75 11                	jne    ffffffff80312b89 <avc_has_perm_noaudit+0x96>

quick guess: cache-cold-miss site.

ffffffff80312d04:     8174 	fc                   	cld    
ffffffff80312d05:    26860 	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)

quick guess: unnecessary initialization of something largish via 
memset. Probably:

  security/selinux/avc.c:avc_has_perm_noaudit()'s:
  [...]
        if (avd)
                memcpy(avd, &p_ae->avd, sizeof(*avd));

but one of the fattest ones:

ffffffff80312e28:        0 	0f 85 b6 fd ff ff    	jne    ffffffff80312be4 <avc_has_perm_noaudit+0xf1>
ffffffff80312e2e:   104641 	e9 86 fd ff ff       	jmpq   ffffffff80312bb9 <avc_has_perm_noaudit+0xc6>
ffffffff80312e33:     2106 	48 83 c4 68          	add    $0x68,%rsp

that seems to be either a branch mispredict (seems a tad expensive for 
that though), or a cachemiss delayed to the first non-predicted 
branch. Ah, that's most likely the case, we fall through straight from 
here:

ffffffff80312dfd:        0      f0 ff 0d 60 65 78 00    lock decl 0x786560(%rip)

that's an atomic op of some global address, in the hotpath. Not good.

the wider context is:

ffffffff80312e1d:    35502 	8b 44 24 0c          	mov    0xc(%rsp),%eax
ffffffff80312e21:     4360 	23 43 10             	and    0x10(%rbx),%eax
ffffffff80312e24:        0 	3b 44 24 0c          	cmp    0xc(%rsp),%eax
ffffffff80312e28:        0 	0f 85 b6 fd ff ff    	jne    ffffffff80312be4 <avc_has_perm_noaudit+0xf1>
ffffffff80312e2e:   104641 	e9 86 fd ff ff       	jmpq   ffffffff80312bb9 <avc_has_perm_noaudit+0xc6>
ffffffff80312e33:     2106 	48 83 c4 68          	add    $0x68,%rsp

ah, yes. My guess is that the "and (%rbx)" at ffffffff80312e21 
generated this miss, and this all is avc_update_node()'s 
for-each-list-loop, and:

        spin_lock_irqsave(&avc_cache.slots_lock[hvalue], flag);

that hash doesnt seem to be working well here. It's done via:

static inline int avc_hash(u32 ssid, u32 tsid, u16 tclass)
{
        return (ssid ^ (tsid<<2) ^ (tclass<<4)) & (AVC_CACHE_SLOTS - 1);
}

AVC_CACHE_SLOTS is 512 - but my usecase is likely has a much narrower 
hash key space than that. Increasing the hash wont work, these kind of 
things really only start scaling once some natural per-CPU construct 
is found to it.

And things like this:

        /* cache hit */
        if (atomic_read(&ret->ae.used) != 1)
                atomic_set(&ret->ae.used, 1);

in avc_search_node() dont really help either as they immediately dirty 
the cacheline in the cache-hit case. Hashed fastpath lookup really 
should only be used to validate security rules in a read-mostly way, 
and cachelines should never be dirtied, as long as it can be avoided.

Anyway, this function needs a good scalability look as it represents 
3.9% of the total tbench cost. I'd not be surprised if it was possible 
more than half of that cost via not too ugly changes.

	Ingo
