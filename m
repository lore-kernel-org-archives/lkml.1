Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYKQU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYKQU6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYKQU6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:58:08 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:41266 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYKQU6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:58:07 -0500
Message-ID: <4921DAC8.6050600@cosmosbay.com>
Date: Mon, 17 Nov 2008 21:57:44 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: ip_queue_xmit(): Re: [Bug #11308] tbench regression on each kernel
 release from 2.6.22 -&gt; 2.6.28
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117203219.GC12020@elte.hu>
In-Reply-To: <20081117203219.GC12020@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 17 Nov 2008 21:57:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> 100.000000 total
>> ................
>>   3.356152 ip_queue_xmit
> 
>                       hits (335615 total)
>                  .........
> ffffffff804b7045:     1001 <ip_queue_xmit>:
> ffffffff804b7045:     1001 	41 57                	push   %r15
> ffffffff804b7047:    36698 	41 56                	push   %r14
> ffffffff804b7049:        0 	49 89 fe             	mov    %rdi,%r14
> ffffffff804b704c:        0 	41 55                	push   %r13
> ffffffff804b704e:      447 	41 54                	push   %r12
> ffffffff804b7050:        0 	55                   	push   %rbp
> ffffffff804b7051:        4 	53                   	push   %rbx
> ffffffff804b7052:      465 	48 83 ec 68          	sub    $0x68,%rsp
> ffffffff804b7056:        1 	89 74 24 08          	mov    %esi,0x8(%rsp)
> ffffffff804b705a:      486 	48 8b 47 28          	mov    0x28(%rdi),%rax
> ffffffff804b705e:        0 	48 8b 6f 10          	mov    0x10(%rdi),%rbp
> ffffffff804b7062:        7 	48 85 c0             	test   %rax,%rax
> ffffffff804b7065:      480 	48 89 44 24 58       	mov    %rax,0x58(%rsp)
> ffffffff804b706a:        0 	4c 8b bd 48 02 00 00 	mov    0x248(%rbp),%r15
> ffffffff804b7071:        7 	0f 85 0d 01 00 00    	jne    ffffffff804b7184 <ip_queue_xmit+0x13f>
> ffffffff804b7077:      452 	31 f6                	xor    %esi,%esi
> ffffffff804b7079:        0 	48 89 ef             	mov    %rbp,%rdi
> ffffffff804b707c:        5 	e8 c1 eb fc ff       	callq  ffffffff80485c42 <__sk_dst_check>
> ffffffff804b7081:      434 	48 85 c0             	test   %rax,%rax
> ffffffff804b7084:       54 	48 89 44 24 58       	mov    %rax,0x58(%rsp)
> ffffffff804b7089:        0 	0f 85 e0 00 00 00    	jne    ffffffff804b716f <ip_queue_xmit+0x12a>
> ffffffff804b708f:        0 	4d 85 ff             	test   %r15,%r15
> ffffffff804b7092:        0 	44 8b ad 30 02 00 00 	mov    0x230(%rbp),%r13d
> ffffffff804b7099:        0 	74 0a                	je     ffffffff804b70a5 <ip_queue_xmit+0x60>
> ffffffff804b709b:        0 	41 80 7f 05 00       	cmpb   $0x0,0x5(%r15)
> ffffffff804b70a0:        0 	74 03                	je     ffffffff804b70a5 <ip_queue_xmit+0x60>
> ffffffff804b70a2:        0 	45 8b 2f             	mov    (%r15),%r13d
> ffffffff804b70a5:        0 	8b 85 3c 02 00 00    	mov    0x23c(%rbp),%eax
> ffffffff804b70ab:        0 	48 8d b5 10 01 00 00 	lea    0x110(%rbp),%rsi
> ffffffff804b70b2:        0 	44 8b 65 04          	mov    0x4(%rbp),%r12d
> ffffffff804b70b6:        0 	bf 0d 00 00 00       	mov    $0xd,%edi
> ffffffff804b70bb:        0 	89 44 24 0c          	mov    %eax,0xc(%rsp)
> ffffffff804b70bf:        0 	8a 9d 54 02 00 00    	mov    0x254(%rbp),%bl
> ffffffff804b70c5:        0 	e8 9a df ff ff       	callq  ffffffff804b5064 <constant_test_bit>
> ffffffff804b70ca:        0 	31 d2                	xor    %edx,%edx
> ffffffff804b70cc:        0 	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
> ffffffff804b70d1:        0 	41 89 c3             	mov    %eax,%r11d
> ffffffff804b70d4:        0 	fc                   	cld    
> ffffffff804b70d5:        0 	89 d0                	mov    %edx,%eax
> ffffffff804b70d7:        0 	b9 10 00 00 00       	mov    $0x10,%ecx
> ffffffff804b70dc:        0 	44 8a 45 39          	mov    0x39(%rbp),%r8b
> ffffffff804b70e0:        0 	40 8a b5 57 02 00 00 	mov    0x257(%rbp),%sil
> ffffffff804b70e7:        0 	44 8b 8d 50 02 00 00 	mov    0x250(%rbp),%r9d
> ffffffff804b70ee:        0 	83 e3 1e             	and    $0x1e,%ebx
> ffffffff804b70f1:        0 	44 8b 95 38 02 00 00 	mov    0x238(%rbp),%r10d
> ffffffff804b70f8:        0 	44 09 db             	or     %r11d,%ebx
> ffffffff804b70fb:        0 	f3 ab                	rep stos %eax,%es:(%rdi)
> ffffffff804b70fd:        0 	40 c0 ee 05          	shr    $0x5,%sil
> ffffffff804b7101:        0 	88 5c 24 24          	mov    %bl,0x24(%rsp)
> ffffffff804b7105:        0 	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
> ffffffff804b710a:        0 	83 e6 01             	and    $0x1,%esi
> ffffffff804b710d:        0 	48 89 ef             	mov    %rbp,%rdi
> ffffffff804b7110:        0 	44 88 44 24 40       	mov    %r8b,0x40(%rsp)
> ffffffff804b7115:        0 	8b 44 24 0c          	mov    0xc(%rsp),%eax
> ffffffff804b7119:        0 	40 88 74 24 41       	mov    %sil,0x41(%rsp)
> ffffffff804b711e:        0 	48 89 de             	mov    %rbx,%rsi
> ffffffff804b7121:        0 	66 44 89 4c 24 44    	mov    %r9w,0x44(%rsp)
> ffffffff804b7127:        0 	66 44 89 54 24 46    	mov    %r10w,0x46(%rsp)
> ffffffff804b712d:        0 	44 89 64 24 10       	mov    %r12d,0x10(%rsp)
> ffffffff804b7132:        0 	44 89 6c 24 1c       	mov    %r13d,0x1c(%rsp)
> ffffffff804b7137:        0 	89 44 24 20          	mov    %eax,0x20(%rsp)
> ffffffff804b713b:        0 	e8 2d 9f e5 ff       	callq  ffffffff8031106d <security_sk_classify_flow>
> ffffffff804b7140:        0 	48 8d 74 24 58       	lea    0x58(%rsp),%rsi
> ffffffff804b7145:        0 	45 31 c0             	xor    %r8d,%r8d
> ffffffff804b7148:        0 	48 89 e9             	mov    %rbp,%rcx
> ffffffff804b714b:        0 	48 89 da             	mov    %rbx,%rdx
> ffffffff804b714e:        0 	48 c7 c7 d0 15 ab 80 	mov    $0xffffffff80ab15d0,%rdi
> ffffffff804b7155:        0 	e8 1a 91 ff ff       	callq  ffffffff804b0274 <ip_route_output_flow>
> ffffffff804b715a:        0 	85 c0                	test   %eax,%eax
> ffffffff804b715c:        0 	0f 85 9f 01 00 00    	jne    ffffffff804b7301 <ip_queue_xmit+0x2bc>
> ffffffff804b7162:        0 	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
> ffffffff804b7167:        0 	48 89 ef             	mov    %rbp,%rdi
> ffffffff804b716a:        0 	e8 a8 eb fc ff       	callq  ffffffff80485d17 <sk_setup_caps>
> ffffffff804b716f:      441 	48 8b 44 24 58       	mov    0x58(%rsp),%rax
> ffffffff804b7174:     1388 	48 85 c0             	test   %rax,%rax
> ffffffff804b7177:        0 	74 07                	je     ffffffff804b7180 <ip_queue_xmit+0x13b>
> ffffffff804b7179:        0 	f0 ff 80 b0 00 00 00 	lock incl 0xb0(%rax)
> ffffffff804b7180:      556 	49 89 46 28          	mov    %rax,0x28(%r14)
> ffffffff804b7184:     8351 	4d 85 ff             	test   %r15,%r15
> ffffffff804b7187:        0 	be 14 00 00 00       	mov    $0x14,%esi
> ffffffff804b718c:      461 	74 26                	je     ffffffff804b71b4 <ip_queue_xmit+0x16f>
> ffffffff804b718e:        0 	41 f6 47 08 01       	testb  $0x1,0x8(%r15)
> ffffffff804b7193:        0 	74 17                	je     ffffffff804b71ac <ip_queue_xmit+0x167>
> ffffffff804b7195:        0 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
> ffffffff804b719a:        0 	8b 82 28 01 00 00    	mov    0x128(%rdx),%eax
> ffffffff804b71a0:        0 	39 82 1c 01 00 00    	cmp    %eax,0x11c(%rdx)
> ffffffff804b71a6:        0 	0f 85 55 01 00 00    	jne    ffffffff804b7301 <ip_queue_xmit+0x2bc>
> ffffffff804b71ac:        0 	41 0f b6 47 04       	movzbl 0x4(%r15),%eax
> ffffffff804b71b1:        0 	8d 70 14             	lea    0x14(%rax),%esi
> ffffffff804b71b4:       39 	4c 89 f7             	mov    %r14,%rdi
> ffffffff804b71b7:      493 	e8 f8 18 fd ff       	callq  ffffffff80488ab4 <skb_push>
> ffffffff804b71bc:        0 	4c 89 f7             	mov    %r14,%rdi
> ffffffff804b71bf:     1701 	e8 99 df ff ff       	callq  ffffffff804b515d <skb_reset_network_header>
> ffffffff804b71c4:      481 	0f b6 85 54 02 00 00 	movzbl 0x254(%rbp),%eax
> ffffffff804b71cb:     4202 	41 8b 9e bc 00 00 00 	mov    0xbc(%r14),%ebx
> ffffffff804b71d2:        3 	48 89 ef             	mov    %rbp,%rdi
> ffffffff804b71d5:        0 	49 03 9e d0 00 00 00 	add    0xd0(%r14),%rbx
> ffffffff804b71dc:      466 	80 cc 45             	or     $0x45,%ah
> ffffffff804b71df:        7 	66 c1 c0 08          	rol    $0x8,%ax
> ffffffff804b71e3:        0 	66 89 03             	mov    %ax,(%rbx)
> ffffffff804b71e6:      492 	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
> ffffffff804b71eb:        3 	e8 a0 df ff ff       	callq  ffffffff804b5190 <ip_dont_fragment>
> ffffffff804b71f0:     1405 	85 c0                	test   %eax,%eax
> ffffffff804b71f2:     4391 	74 0f                	je     ffffffff804b7203 <ip_queue_xmit+0x1be>
> ffffffff804b71f4:        0 	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
> ffffffff804b71f9:      417 	75 08                	jne    ffffffff804b7203 <ip_queue_xmit+0x1be>
> ffffffff804b71fb:      503 	66 c7 43 06 40 00    	movw   $0x40,0x6(%rbx)
> ffffffff804b7201:     6743 	eb 06                	jmp    ffffffff804b7209 <ip_queue_xmit+0x1c4>
> ffffffff804b7203:        0 	66 c7 43 06 00 00    	movw   $0x0,0x6(%rbx)
> ffffffff804b7209:      118 	0f bf 85 40 02 00 00 	movswl 0x240(%rbp),%eax
> ffffffff804b7210:    10867 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
> ffffffff804b7215:      340 	85 c0                	test   %eax,%eax
> ffffffff804b7217:        0 	79 06                	jns    ffffffff804b721f <ip_queue_xmit+0x1da>
> ffffffff804b7219:   107464 	8b 82 9c 00 00 00    	mov    0x9c(%rdx),%eax
> ffffffff804b721f:     4963 	88 43 08             	mov    %al,0x8(%rbx)
> ffffffff804b7222:    26297 	8a 45 39             	mov    0x39(%rbp),%al
> ffffffff804b7225:    76658 	4d 85 ff             	test   %r15,%r15
> ffffffff804b7228:     1712 	88 43 09             	mov    %al,0x9(%rbx)
> ffffffff804b722b:      148 	48 8b 44 24 58       	mov    0x58(%rsp),%rax
> ffffffff804b7230:     2971 	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
> ffffffff804b7236:    14849 	89 43 0c             	mov    %eax,0xc(%rbx)
> ffffffff804b7239:       84 	48 8b 44 24 58       	mov    0x58(%rsp),%rax
> ffffffff804b723e:      360 	8b 80 1c 01 00 00    	mov    0x11c(%rax),%eax
> ffffffff804b7244:      174 	89 43 10             	mov    %eax,0x10(%rbx)
> ffffffff804b7247:       96 	74 32                	je     ffffffff804b727b <ip_queue_xmit+0x236>
> ffffffff804b7249:        0 	41 8a 57 04          	mov    0x4(%r15),%dl
> ffffffff804b724d:        0 	84 d2                	test   %dl,%dl
> ffffffff804b724f:        0 	74 2a                	je     ffffffff804b727b <ip_queue_xmit+0x236>
> ffffffff804b7251:        0 	c0 ea 02             	shr    $0x2,%dl
> ffffffff804b7254:        0 	03 13                	add    (%rbx),%edx
> ffffffff804b7256:        0 	8a 03                	mov    (%rbx),%al
> ffffffff804b7258:        0 	45 31 c0             	xor    %r8d,%r8d
> ffffffff804b725b:        0 	4c 89 fe             	mov    %r15,%rsi
> ffffffff804b725e:        0 	4c 89 f7             	mov    %r14,%rdi
> ffffffff804b7261:        0 	83 e0 f0             	and    $0xfffffffffffffff0,%eax
> ffffffff804b7264:        0 	83 e2 0f             	and    $0xf,%edx
> ffffffff804b7267:        0 	09 d0                	or     %edx,%eax
> ffffffff804b7269:        0 	88 03                	mov    %al,(%rbx)
> ffffffff804b726b:        0 	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
> ffffffff804b7270:        0 	8b 95 30 02 00 00    	mov    0x230(%rbp),%edx
> ffffffff804b7276:        0 	e8 e4 d8 ff ff       	callq  ffffffff804b4b5f <ip_options_build>
> ffffffff804b727b:      541 	41 8b 86 c8 00 00 00 	mov    0xc8(%r14),%eax
> ffffffff804b7282:      570 	31 d2                	xor    %edx,%edx
> ffffffff804b7284:        0 	49 03 86 d0 00 00 00 	add    0xd0(%r14),%rax
> ffffffff804b728b:       34 	8b 40 08             	mov    0x8(%rax),%eax
> ffffffff804b728e:      496 	66 85 c0             	test   %ax,%ax
> ffffffff804b7291:       11 	74 06                	je     ffffffff804b7299 <ip_queue_xmit+0x254>
> ffffffff804b7293:        9 	0f b7 c0             	movzwl %ax,%eax
> ffffffff804b7296:      495 	8d 50 ff             	lea    -0x1(%rax),%edx
> ffffffff804b7299:        2 	f6 43 06 40          	testb  $0x40,0x6(%rbx)
> ffffffff804b729d:        9 	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
> ffffffff804b72a2:      497 	74 34                	je     ffffffff804b72d8 <ip_queue_xmit+0x293>
> ffffffff804b72a4:        8 	83 bd 30 02 00 00 00 	cmpl   $0x0,0x230(%rbp)
> ffffffff804b72ab:       10 	74 23                	je     ffffffff804b72d0 <ip_queue_xmit+0x28b>
> ffffffff804b72ad:     1044 	66 8b 85 52 02 00 00 	mov    0x252(%rbp),%ax
> ffffffff804b72b4:        7 	66 c1 c0 08          	rol    $0x8,%ax
> ffffffff804b72b8:        8 	66 89 43 04          	mov    %ax,0x4(%rbx)
> ffffffff804b72bc:      432 	66 8b 85 52 02 00 00 	mov    0x252(%rbp),%ax
> ffffffff804b72c3:        9 	ff c0                	inc    %eax
> ffffffff804b72c5:       14 	01 d0                	add    %edx,%eax
> ffffffff804b72c7:     1141 	66 89 85 52 02 00 00 	mov    %ax,0x252(%rbp)
> ffffffff804b72ce:        7 	eb 10                	jmp    ffffffff804b72e0 <ip_queue_xmit+0x29b>
> ffffffff804b72d0:        0 	66 c7 43 04 00 00    	movw   $0x0,0x4(%rbx)
> ffffffff804b72d6:        0 	eb 08                	jmp    ffffffff804b72e0 <ip_queue_xmit+0x29b>
> ffffffff804b72d8:        0 	48 89 df             	mov    %rbx,%rdi
> ffffffff804b72db:        0 	e8 b7 9d ff ff       	callq  ffffffff804b1097 <__ip_select_ident>
> ffffffff804b72e0:        6 	8b 85 54 01 00 00    	mov    0x154(%rbp),%eax
> ffffffff804b72e6:      458 	4c 89 f7             	mov    %r14,%rdi
> ffffffff804b72e9:        2 	41 89 46 78          	mov    %eax,0x78(%r14)
> ffffffff804b72ed:        4 	8b 85 f0 01 00 00    	mov    0x1f0(%rbp),%eax
> ffffffff804b72f3:      841 	41 89 86 b0 00 00 00 	mov    %eax,0xb0(%r14)
> ffffffff804b72fa:       11 	e8 30 f2 ff ff       	callq  ffffffff804b652f <ip_local_out>
> ffffffff804b72ff:        0 	eb 44                	jmp    ffffffff804b7345 <ip_queue_xmit+0x300>
> ffffffff804b7301:        0 	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
> ffffffff804b7308:        0 	00 00 
> ffffffff804b730a:        0 	8b 80 48 e0 ff ff    	mov    -0x1fb8(%rax),%eax
> ffffffff804b7310:        0 	4c 89 f7             	mov    %r14,%rdi
> ffffffff804b7313:        0 	30 c0                	xor    %al,%al
> ffffffff804b7315:        0 	66 83 f8 01          	cmp    $0x1,%ax
> ffffffff804b7319:        0 	48 19 c0             	sbb    %rax,%rax
> ffffffff804b731c:        0 	83 e0 08             	and    $0x8,%eax
> ffffffff804b731f:        0 	48 8b 90 a8 16 ab 80 	mov    -0x7f54e958(%rax),%rdx
> ffffffff804b7326:        0 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
> ffffffff804b732d:        0 	00 
> ffffffff804b732e:        0 	89 c0                	mov    %eax,%eax
> ffffffff804b7330:        0 	48 f7 d2             	not    %rdx
> ffffffff804b7333:        0 	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
> ffffffff804b7337:        0 	48 ff 40 68          	incq   0x68(%rax)
> ffffffff804b733b:        0 	e8 b1 18 fd ff       	callq  ffffffff80488bf1 <kfree_skb>
> ffffffff804b7340:        0 	b8 8f ff ff ff       	mov    $0xffffff8f,%eax
> ffffffff804b7345:     9196 	48 83 c4 68          	add    $0x68,%rsp
> ffffffff804b7349:      892 	5b                   	pop    %rbx
> ffffffff804b734a:        0 	5d                   	pop    %rbp
> ffffffff804b734b:      488 	41 5c                	pop    %r12
> ffffffff804b734d:        0 	41 5d                	pop    %r13
> ffffffff804b734f:        0 	41 5e                	pop    %r14
> ffffffff804b7351:      513 	41 5f                	pop    %r15
> ffffffff804b7353:        0 	c3                   	retq   
> 
> about 10% of this function's cost is artificial:
> 
> ffffffff804b7045:     1001 <ip_queue_xmit>:
> ffffffff804b7045:     1001 	41 57                	push   %r15
> ffffffff804b7047:    36698 	41 56                	push   %r14
> 
> there are profiler hits that leaked in via out-of-order execution from 
> the callsites. The callsites are hard to map unfortunately, as this 
> function is called via function pointers.
> 
> the most likely callsite is tcp_transmit_skb().
> 
> 30% of the overhead of this function comes from:
> 
> ffffffff804b7203:        0 	66 c7 43 06 00 00    	movw   $0x0,0x6(%rbx)
> ffffffff804b7209:      118 	0f bf 85 40 02 00 00 	movswl 0x240(%rbp),%eax
> ffffffff804b7210:    10867 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
> ffffffff804b7215:      340 	85 c0                	test   %eax,%eax
> ffffffff804b7217:        0 	79 06                	jns    ffffffff804b721f <ip_queue_xmit+0x1da>
> ffffffff804b7219:   107464 	8b 82 9c 00 00 00    	mov    0x9c(%rdx),%eax
> ffffffff804b721f:     4963 	88 43 08             	mov    %al,0x8(%rbx)
> 
> the 16-bit movw looks a bit weird. It comes from line 372:
> 
>  0xffffffff804b7203 is in ip_queue_xmit (net/ipv4/ip_output.c:372).
>  367		iph = ip_hdr(skb);
>  368		*((__be16 *)iph) = htons((4 << 12) | (5 << 8) | (inet->tos & 0xff));
>  369		if (ip_dont_fragment(sk, &rt->u.dst) && !ipfragok)
>  370			iph->frag_off = htons(IP_DF);
>  371		else
>  372			iph->frag_off = 0;
>  373		iph->ttl      = ip_select_ttl(inet, &rt->u.dst);
>  374		iph->protocol = sk->sk_protocol;
>  375		iph->saddr    = rt->rt_src;
>  376		iph->daddr    = rt->rt_dst;
> 
> the ip-header fragment flag setting to zero.
> 
> 16-bit ops are an on-off love/hate affair on x86 CPUs. The trend is 
> towards eliminating them as much as possible.
> 
> _But_, the real overhead probably comes from:
> 
>  ffffffff804b7210:    10867 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
> 
> which is the next line, the ttl field:
> 
>  373             iph->ttl      = ip_select_ttl(inet, &rt->u.dst);
> 
> this shows that we are doing a hard cachemiss on the net-localhost 
> route dst structure cacheline. We do a plain load instruction from it 
> here and get a hefty cachemiss. (because 16 CPUs are banging on that 
> single route)
> 
> And let make sure we see this in perspective as well: that single 
> cachemiss is _1.0 percent_ of the total tbench cost. (!) We could make 
> the scheduler 10% slower straight away and it would have less of a 
> real-life effect than this single iph->ttl field setting.
> 

If you applied my patch against dst_entry, then you should not have any cache
line miss accessing the first and second cache line of dst_entry, that are mostly
read (and contains all metrics, like ttl at offset 0x58 ). Or something is
really wrong...

Now if your cpu cache is blown away because of the huge send()/receive() done
by tbench, we are stuck of course.

I dont know what you want to prove here. We already have one dst_entry per route in
the rt cache, and it already can consume *lot* of ram if you have 1 million entries
in rt cache.

tbench is mostly a network benchmark (and one using loopback device), thats not a 
suprise it can stress network part or the kernel :)



