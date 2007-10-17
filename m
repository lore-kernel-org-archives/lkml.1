Return-Path: <linux-kernel-owner+w=401wt.eu-S936294AbXJQRq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936294AbXJQRq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762843AbXJQRqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:46:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762909AbXJQRql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:46:41 -0400
Date: Wed, 17 Oct 2007 19:45:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017174503.GA4622@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017173408.GA1960@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ok, here's a different but similar crash that triggers on the testbox:

[  233.438890] BUG: unable to handle kernel paging request at virtual address 7d93e000
[  233.446390] printing eip: 784e9480 *pde = 01000067 *pte = 0593e000 
[  233.452630] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  233.456790] 
[  233.458264] Pid: 0, comm: swapper Not tainted (2.6.23 #5)
[  233.463637] EIP: 0060:[<784e9480>] EFLAGS: 00010087 CPU: 0
[  233.469101] EIP is at ata_qc_issue+0x90/0x380
[  233.473429] EAX: 7d93dff0 EBX: 0000001f ECX: 7d93dff0 EDX: 798daf80
[  233.479668] ESI: 00000020 EDI: 7d93de00 EBP: 7b54007c ESP: 78a13e14
[  233.485908]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  233.491282] Process swapper (pid: 0, ti=78a12000 task=789753e0 task.ti=78a12000)
[  233.498473] Stack: 7d93de00 7b540000 7b540000 00000000 7d93dfe0 7b54007c 7d93db00 7b5417a4 
[  233.506793]        784c2490 784ef69e 784f21f3 7b52de98 7d93db00 7b540000 7b5417a4 7d93db00 
[  233.515112]        7b540000 7b524004 784f22e0 784ef380 784c2490 7d93db00 00000202 7b524004 
[  233.523432] Call Trace:
[  233.526033]  [<784c2490>] scsi_done+0x0/0x20
[  233.530279]  [<784ef69e>] ata_scsi_translate+0xbe/0x140
[  233.535478]  [<784f21f3>] ata_scsi_queuecmd+0x33/0x200
[  233.540591]  [<784f22e0>] ata_scsi_queuecmd+0x120/0x200
[  233.545791]  [<784ef380>] ata_scsi_rw_xlat+0x0/0x220
[  233.550730]  [<784c2490>] scsi_done+0x0/0x20
[  233.554976]  [<784c2d12>] scsi_dispatch_cmd+0x152/0x290
[  233.560177]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[  233.565202]  [<784c8c7e>] scsi_request_fn+0x1be/0x370
[  233.570229]  [<78408086>] blk_run_queue+0x36/0x80
[  233.574909]  [<784c7520>] scsi_next_command+0x30/0x50
[  233.579935]  [<784c76ab>] scsi_end_request+0xab/0xe0
[  233.584875]  [<784c83f9>] scsi_io_completion+0xa9/0x3d0
[  233.590075]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[  233.595100]  [<78405125>] blk_done_softirq+0x45/0x80
[  233.600040]  [<78405153>] blk_done_softirq+0x73/0x80
[  233.604981]  [<7811d4c3>] __do_softirq+0x53/0xb0
[  233.609573]  [<7811d588>] do_softirq+0x68/0x70
[  233.613993]  [<78105351>] do_IRQ+0x51/0x90
[  233.618066]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
[  233.623092]  [<7810f2d0>] pgd_dtor+0x0/0x50
[  233.627252]  [<7810388e>] common_interrupt+0x2e/0x40
[  233.632192]  [<7810f2d0>] pgd_dtor+0x0/0x50
[  233.636352]  [<7815f3be>] quicklist_trim+0x5e/0x90
[  233.641118]  [<7810f2cb>] check_pgt_cache+0x1b/0x20
[  233.645971]  [<78100c52>] cpu_idle+0x32/0x60
[  233.650217]  [<78a14b35>] start_kernel+0x265/0x300
[  233.654983]  [<78a14380>] unknown_bootoption+0x0/0x1e0
[  233.660097]  =======================
[  233.663649] Code: 00 00 00 8b 45 34 a8 02 0f 84 ed 00 00 00 8b bd 88 00 00 00 31 db 89 3c 24 8b 75 3c 89 f8 c7 44 24 10 00 00 00 00 eb 1b 8d 76 00 <8b> 50 10 8d 48 10 f6 c2 01 0f 85 be 02 00 00 89 44 24 10 83 c3 
[  233.682455] EIP: [<784e9480>] ata_qc_issue+0x90/0x380 SS:ESP 0068:78a13e14
[  233.689302] Kernel panic - not syncing: Fatal exception in interrupt

(gdb) list *0x784e9480
0x784e9480 is in ata_qc_issue (include/linux/scatterlist.h:48).
43       */
44      static inline struct scatterlist *sg_next(struct scatterlist *sg)
45      {
46              sg++;
47
48              if (unlikely(sg_is_chain(sg)))
49                      sg = sg_chain_ptr(sg);
50
51              return sg;
52      }
(gdb)

so there's sg_next() involvement too. Below is the disassembly.

	Ingo

------------------------->
784e93f0 <ata_qc_issue>:
784e93f0:	55                   	push   %ebp
784e93f1:	89 c5                	mov    %eax,%ebp
784e93f3:	57                   	push   %edi
784e93f4:	56                   	push   %esi
784e93f5:	53                   	push   %ebx
784e93f6:	83 ec 14             	sub    $0x14,%esp
784e93f9:	8b 00                	mov    (%eax),%eax
784e93fb:	89 44 24 04          	mov    %eax,0x4(%esp)
784e93ff:	8b 45 04             	mov    0x4(%ebp),%eax
784e9402:	80 7d 14 04          	cmpb   $0x4,0x14(%ebp)
784e9406:	8b 10                	mov    (%eax),%edx
784e9408:	0f 84 d2 01 00 00    	je     784e95e0 <ata_qc_issue+0x1f0>
784e940e:	8b 5c 24 04          	mov    0x4(%esp),%ebx
784e9412:	83 83 84 16 00 00 01 	addl   $0x1,0x1684(%ebx)
784e9419:	8b 45 38             	mov    0x38(%ebp),%eax
784e941c:	89 42 08             	mov    %eax,0x8(%edx)
784e941f:	83 4d 34 01          	orl    $0x1,0x34(%ebp)
784e9423:	b8 01 00 00 00       	mov    $0x1,%eax
784e9428:	8b 4d 38             	mov    0x38(%ebp),%ecx
784e942b:	89 c7                	mov    %eax,%edi
784e942d:	8b 54 24 04          	mov    0x4(%esp),%edx
784e9431:	d3 e7                	shl    %cl,%edi
784e9433:	09 ba 80 16 00 00    	or     %edi,0x1680(%edx)
784e9439:	8b 4d 00             	mov    0x0(%ebp),%ecx
784e943c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
784e9440:	80 7d 14 07          	cmpb   $0x7,0x14(%ebp)
784e9444:	0f 87 c6 00 00 00    	ja     784e9510 <ata_qc_issue+0x120>
784e944a:	0f be 4d 14          	movsbl 0x14(%ebp),%ecx
784e944e:	d3 e0                	shl    %cl,%eax
784e9450:	a8 98                	test   $0x98,%al
784e9452:	0f 84 ab 00 00 00    	je     784e9503 <ata_qc_issue+0x113>
784e9458:	8b 45 34             	mov    0x34(%ebp),%eax
784e945b:	a8 02                	test   $0x2,%al
784e945d:	0f 84 ed 00 00 00    	je     784e9550 <ata_qc_issue+0x160>
784e9463:	8b bd 88 00 00 00    	mov    0x88(%ebp),%edi
784e9469:	31 db                	xor    %ebx,%ebx
784e946b:	89 3c 24             	mov    %edi,(%esp)
784e946e:	8b 75 3c             	mov    0x3c(%ebp),%esi
784e9471:	89 f8                	mov    %edi,%eax
784e9473:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
784e947a:	00 
784e947b:	eb 1b                	jmp    784e9498 <ata_qc_issue+0xa8>
784e947d:	8d 76 00             	lea    0x0(%esi),%esi
784e9480:	8b 50 10             	mov    0x10(%eax),%edx
784e9483:	8d 48 10             	lea    0x10(%eax),%ecx
784e9486:	f6 c2 01             	test   $0x1,%dl
784e9489:	0f 85 be 02 00 00    	jne    784e974d <ata_qc_issue+0x35d>
784e948f:	89 44 24 10          	mov    %eax,0x10(%esp)
784e9493:	83 c3 01             	add    $0x1,%ebx
784e9496:	89 c8                	mov    %ecx,%eax
784e9498:	39 f3                	cmp    %esi,%ebx
784e949a:	75 e4                	jne    784e9480 <ata_qc_issue+0x90>
784e949c:	8b 54 24 10          	mov    0x10(%esp),%edx
784e94a0:	8b 42 0c             	mov    0xc(%edx),%eax
784e94a3:	83 e0 03             	and    $0x3,%eax
784e94a6:	85 c0                	test   %eax,%eax
784e94a8:	89 45 4c             	mov    %eax,0x4c(%ebp)
784e94ab:	0f 85 53 01 00 00    	jne    784e9604 <ata_qc_issue+0x214>
784e94b1:	89 f1                	mov    %esi,%ecx
784e94b3:	83 f9 00             	cmp    $0x0,%ecx
784e94b6:	0f 84 df 01 00 00    	je     784e969b <ata_qc_issue+0x2ab>
784e94bc:	7e 30                	jle    784e94ee <ata_qc_issue+0xfe>
784e94be:	31 d2                	xor    %edx,%edx
784e94c0:	8b 1c 24             	mov    (%esp),%ebx
784e94c3:	83 c2 01             	add    $0x1,%edx
784e94c6:	8b 03                	mov    (%ebx),%eax
784e94c8:	2b 05 f8 ec d7 78    	sub    0x78d7ecf8,%eax
784e94ce:	c1 f8 05             	sar    $0x5,%eax
784e94d1:	c1 e0 0c             	shl    $0xc,%eax
784e94d4:	03 43 04             	add    0x4(%ebx),%eax
784e94d7:	89 43 08             	mov    %eax,0x8(%ebx)
784e94da:	83 c3 10             	add    $0x10,%ebx
784e94dd:	89 1c 24             	mov    %ebx,(%esp)
784e94e0:	8b 03                	mov    (%ebx),%eax
784e94e2:	a8 01                	test   $0x1,%al
784e94e4:	0f 85 6d 02 00 00    	jne    784e9757 <ata_qc_issue+0x367>
784e94ea:	39 ca                	cmp    %ecx,%edx
784e94ec:	75 d2                	jne    784e94c0 <ata_qc_issue+0xd0>
784e94ee:	f0 83 44 24 00 00    	lock addl $0x0,0x0(%esp)
784e94f4:	85 c9                	test   %ecx,%ecx
784e94f6:	89 c8                	mov    %ecx,%eax
784e94f8:	0f 8e 2c 02 00 00    	jle    784e972a <ata_qc_issue+0x33a>
784e94fe:	89 45 3c             	mov    %eax,0x3c(%ebp)
784e9501:	eb 11                	jmp    784e9514 <ata_qc_issue+0x124>
784e9503:	a8 24                	test   $0x24,%al
784e9505:	0f 85 b5 00 00 00    	jne    784e95c0 <ata_qc_issue+0x1d0>
784e950b:	90                   	nop    
784e950c:	8d 74 26 00          	lea    0x0(%esi),%esi
784e9510:	83 65 34 f9          	andl   $0xfffffff9,0x34(%ebp)
784e9514:	8b 5c 24 04          	mov    0x4(%esp),%ebx
784e9518:	89 e8                	mov    %ebp,%eax
784e951a:	8b 53 04             	mov    0x4(%ebx),%edx
784e951d:	ff 52 48             	call   *0x48(%edx)
784e9520:	8b 9d 8c 00 00 00    	mov    0x8c(%ebp),%ebx
784e9526:	89 e8                	mov    %ebp,%eax
784e9528:	8b 7c 24 04          	mov    0x4(%esp),%edi
784e952c:	8b 57 04             	mov    0x4(%edi),%edx
784e952f:	ff 52 4c             	call   *0x4c(%edx)
784e9532:	09 d8                	or     %ebx,%eax
784e9534:	85 c0                	test   %eax,%eax
784e9536:	89 85 8c 00 00 00    	mov    %eax,0x8c(%ebp)
784e953c:	0f 85 fd 01 00 00    	jne    784e973f <ata_qc_issue+0x34f>
784e9542:	83 c4 14             	add    $0x14,%esp
784e9545:	5b                   	pop    %ebx
784e9546:	5e                   	pop    %esi
784e9547:	5f                   	pop    %edi
784e9548:	5d                   	pop    %ebp
784e9549:	c3                   	ret    
784e954a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
784e9550:	a8 04                	test   $0x4,%al
784e9552:	74 c0                	je     784e9514 <ata_qc_issue+0x124>
784e9554:	8b 95 88 00 00 00    	mov    0x88(%ebp),%edx
784e955a:	8b 42 0c             	mov    0xc(%edx),%eax
784e955d:	83 e0 03             	and    $0x3,%eax
784e9560:	85 c0                	test   %eax,%eax
784e9562:	89 45 4c             	mov    %eax,0x4c(%ebp)
784e9565:	0f 84 3a 01 00 00    	je     784e96a5 <ata_qc_issue+0x2b5>
784e956b:	8b 45 38             	mov    0x38(%ebp),%eax
784e956e:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
784e9575:	8b 44 24 08          	mov    0x8(%esp),%eax
784e9579:	03 78 24             	add    0x24(%eax),%edi
784e957c:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
784e9582:	f6 45 10 08          	testb  $0x8,0x10(%ebp)
784e9586:	0f 85 3a 01 00 00    	jne    784e96c6 <ata_qc_issue+0x2d6>
784e958c:	8b 4c 24 08          	mov    0x8(%esp),%ecx
784e9590:	8b 45 38             	mov    0x38(%ebp),%eax
784e9593:	c1 e0 02             	shl    $0x2,%eax
784e9596:	03 41 28             	add    0x28(%ecx),%eax
784e9599:	c7 85 80 00 00 00 04 	movl   $0x4,0x80(%ebp)
784e95a0:	00 00 00 
784e95a3:	89 45 7c             	mov    %eax,0x7c(%ebp)
784e95a6:	8b 42 0c             	mov    0xc(%edx),%eax
784e95a9:	2b 45 4c             	sub    0x4c(%ebp),%eax
784e95ac:	85 c0                	test   %eax,%eax
784e95ae:	89 42 0c             	mov    %eax,0xc(%edx)
784e95b1:	0f 85 ee 00 00 00    	jne    784e96a5 <ata_qc_issue+0x2b5>
784e95b7:	83 6d 3c 01          	subl   $0x1,0x3c(%ebp)
784e95bb:	e9 54 ff ff ff       	jmp    784e9514 <ata_qc_issue+0x124>
784e95c0:	8b 5c 24 08          	mov    0x8(%esp),%ebx
784e95c4:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
784e95c8:	0f 89 42 ff ff ff    	jns    784e9510 <ata_qc_issue+0x120>
784e95ce:	8b 45 34             	mov    0x34(%ebp),%eax
784e95d1:	a8 02                	test   $0x2,%al
784e95d3:	0f 84 77 ff ff ff    	je     784e9550 <ata_qc_issue+0x160>
784e95d9:	e9 85 fe ff ff       	jmp    784e9463 <ata_qc_issue+0x73>
784e95de:	89 f6                	mov    %esi,%esi
784e95e0:	8b 42 0c             	mov    0xc(%edx),%eax
784e95e3:	85 c0                	test   %eax,%eax
784e95e5:	75 0b                	jne    784e95f2 <ata_qc_issue+0x202>
784e95e7:	8b 4c 24 04          	mov    0x4(%esp),%ecx
784e95eb:	83 81 84 16 00 00 01 	addl   $0x1,0x1684(%ecx)
784e95f2:	8b 4d 38             	mov    0x38(%ebp),%ecx
784e95f5:	b8 01 00 00 00       	mov    $0x1,%eax
784e95fa:	d3 e0                	shl    %cl,%eax
784e95fc:	09 42 0c             	or     %eax,0xc(%edx)
784e95ff:	e9 1b fe ff ff       	jmp    784e941f <ata_qc_issue+0x2f>
784e9604:	8b 45 38             	mov    0x38(%ebp),%eax
784e9607:	8b 4c 24 08          	mov    0x8(%esp),%ecx
784e960b:	c1 e0 02             	shl    $0x2,%eax
784e960e:	89 44 24 0c          	mov    %eax,0xc(%esp)
784e9612:	8b 49 24             	mov    0x24(%ecx),%ecx
784e9615:	01 c8                	add    %ecx,%eax
784e9617:	89 44 24 0c          	mov    %eax,0xc(%esp)
784e961b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
784e9621:	8b 5c 24 10          	mov    0x10(%esp),%ebx
784e9625:	8b 7c 24 10          	mov    0x10(%esp),%edi
784e9629:	8b 53 04             	mov    0x4(%ebx),%edx
784e962c:	03 53 0c             	add    0xc(%ebx),%edx
784e962f:	8b 07                	mov    (%edi),%eax
784e9631:	8b 1d f8 ec d7 78    	mov    0x78d7ecf8,%ebx
784e9637:	2b 55 4c             	sub    0x4c(%ebp),%edx
784e963a:	29 d8                	sub    %ebx,%eax
784e963c:	89 d1                	mov    %edx,%ecx
784e963e:	c1 f8 05             	sar    $0x5,%eax
784e9641:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
784e9647:	c1 e9 0c             	shr    $0xc,%ecx
784e964a:	01 c8                	add    %ecx,%eax
784e964c:	c1 e0 05             	shl    $0x5,%eax
784e964f:	01 c3                	add    %eax,%ebx
784e9651:	f6 45 10 08          	testb  $0x8,0x10(%ebp)
784e9655:	89 5d 74             	mov    %ebx,0x74(%ebp)
784e9658:	89 55 78             	mov    %edx,0x78(%ebp)
784e965b:	0f 85 88 00 00 00    	jne    784e96e9 <ata_qc_issue+0x2f9>
784e9661:	8b 54 24 08          	mov    0x8(%esp),%edx
784e9665:	8b 45 38             	mov    0x38(%ebp),%eax
784e9668:	c1 e0 02             	shl    $0x2,%eax
784e966b:	03 42 28             	add    0x28(%edx),%eax
784e966e:	c7 85 80 00 00 00 04 	movl   $0x4,0x80(%ebp)
784e9675:	00 00 00 
784e9678:	89 45 7c             	mov    %eax,0x7c(%ebp)
784e967b:	8b 4c 24 10          	mov    0x10(%esp),%ecx
784e967f:	8b 41 0c             	mov    0xc(%ecx),%eax
784e9682:	2b 45 4c             	sub    0x4c(%ebp),%eax
784e9685:	85 c0                	test   %eax,%eax
784e9687:	89 41 0c             	mov    %eax,0xc(%ecx)
784e968a:	75 32                	jne    784e96be <ata_qc_issue+0x2ce>
784e968c:	8b 4d 3c             	mov    0x3c(%ebp),%ecx
784e968f:	85 c9                	test   %ecx,%ecx
784e9691:	74 08                	je     784e969b <ata_qc_issue+0x2ab>
784e9693:	83 e9 01             	sub    $0x1,%ecx
784e9696:	e9 18 fe ff ff       	jmp    784e94b3 <ata_qc_issue+0xc3>
784e969b:	31 c0                	xor    %eax,%eax
784e969d:	8d 76 00             	lea    0x0(%esi),%esi
784e96a0:	e9 59 fe ff ff       	jmp    784e94fe <ata_qc_issue+0x10e>
784e96a5:	8b 85 84 00 00 00    	mov    0x84(%ebp),%eax
784e96ab:	f0 83 44 24 00 00    	lock addl $0x0,0x0(%esp)
784e96b1:	2d 00 00 00 78       	sub    $0x78000000,%eax
784e96b6:	89 42 08             	mov    %eax,0x8(%edx)
784e96b9:	e9 56 fe ff ff       	jmp    784e9514 <ata_qc_issue+0x124>
784e96be:	8b 75 3c             	mov    0x3c(%ebp),%esi
784e96c1:	e9 eb fd ff ff       	jmp    784e94b1 <ata_qc_issue+0xc1>
784e96c6:	8b 45 4c             	mov    0x4c(%ebp),%eax
784e96c9:	8b 72 0c             	mov    0xc(%edx),%esi
784e96cc:	03 b5 84 00 00 00    	add    0x84(%ebp),%esi
784e96d2:	89 c1                	mov    %eax,%ecx
784e96d4:	c1 e9 02             	shr    $0x2,%ecx
784e96d7:	29 c6                	sub    %eax,%esi
784e96d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
784e96db:	89 c1                	mov    %eax,%ecx
784e96dd:	83 e1 03             	and    $0x3,%ecx
784e96e0:	74 02                	je     784e96e4 <ata_qc_issue+0x2f4>
784e96e2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
784e96e4:	e9 a3 fe ff ff       	jmp    784e958c <ata_qc_issue+0x19c>
784e96e9:	89 e2                	mov    %esp,%edx
784e96eb:	81 e2 00 e0 ff ff    	and    $0xffffe000,%edx
784e96f1:	83 42 14 01          	addl   $0x1,0x14(%edx)
784e96f5:	8b 45 4c             	mov    0x4c(%ebp),%eax
784e96f8:	2b 1d f8 ec d7 78    	sub    0x78d7ecf8,%ebx
784e96fe:	8b 7c 24 0c          	mov    0xc(%esp),%edi
784e9702:	c1 fb 05             	sar    $0x5,%ebx
784e9705:	89 c1                	mov    %eax,%ecx
784e9707:	c1 e3 0c             	shl    $0xc,%ebx
784e970a:	8d b3 00 00 00 78    	lea    0x78000000(%ebx),%esi
784e9710:	c1 e9 02             	shr    $0x2,%ecx
784e9713:	03 75 78             	add    0x78(%ebp),%esi
784e9716:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
784e9718:	89 c1                	mov    %eax,%ecx
784e971a:	83 e1 03             	and    $0x3,%ecx
784e971d:	74 02                	je     784e9721 <ata_qc_issue+0x331>
784e971f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
784e9721:	83 6a 14 01          	subl   $0x1,0x14(%edx)
784e9725:	e9 37 ff ff ff       	jmp    784e9661 <ata_qc_issue+0x271>
784e972a:	8b 54 24 10          	mov    0x10(%esp),%edx
784e972e:	8b 45 4c             	mov    0x4c(%ebp),%eax
784e9731:	01 42 0c             	add    %eax,0xc(%edx)
784e9734:	83 65 34 f9          	andl   $0xfffffff9,0x34(%ebp)
784e9738:	83 8d 8c 00 00 00 40 	orl    $0x40,0x8c(%ebp)
784e973f:	83 c4 14             	add    $0x14,%esp
784e9742:	89 e8                	mov    %ebp,%eax
784e9744:	5b                   	pop    %ebx
784e9745:	5e                   	pop    %esi
784e9746:	5f                   	pop    %edi
784e9747:	5d                   	pop    %ebp
784e9748:	e9 23 fc ff ff       	jmp    784e9370 <ata_qc_complete>
784e974d:	89 d1                	mov    %edx,%ecx
784e974f:	83 e1 fe             	and    $0xfffffffe,%ecx
784e9752:	e9 38 fd ff ff       	jmp    784e948f <ata_qc_issue+0x9f>
784e9757:	83 e0 fe             	and    $0xfffffffe,%eax
784e975a:	89 04 24             	mov    %eax,(%esp)
784e975d:	e9 88 fd ff ff       	jmp    784e94ea <ata_qc_issue+0xfa>
784e9762:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
784e9769:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

