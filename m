Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbYEFUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbYEFUr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764787AbYEFUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:46:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:13002 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbYEFUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aE/GKPfNYtbS4IXR7CLJSvDohgVkcW4s9lXAQl0hvWI0Di/0RfcwBVqknaVgxQ4SQKz3Mo/FNLxmuVHazdZFiL+jdDtCq9ughlDms6XTt4oCu2DIrBEfqnj1vSxjd8vnLoIDXv6ef8y1buhYPsNx6p+kvq5huskZVj+45wjreVs=
Message-ID: <19f34abd0805061346q4af7e4f8kd65009f8d3021d0e@mail.gmail.com>
Date: Tue, 6 May 2008 22:46:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Lin Ming" <ming.m.lin@intel.com>, "Bob Moore" <robert.moore@intel.com>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <84144f020805061338yd6e3declaf5ff9ca344c28ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805060909q635d2d43j9414e5f179c9e22f@mail.gmail.com>
	 <84144f020805061338yd6e3declaf5ff9ca344c28ba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 10:38 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
> On Tue, May 6, 2008 at 7:09 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>  >  Running kmemcheck on top of v2.6.26-rc1 gives the following (never
>  >  before seen) warning:
>  >
>  >  Linux Plug and Play Support v0.97 (c) Adam Belay
>  >  pnp: PnP ACPI init
>  >  ACPI: bus type pnp registered
>  >  kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
>  >
>  >  Pid: 1, comm: swapper Not tainted (2.6.26-rc1-00010-g7966e04 #2)
>  >  EIP: 0060:[<c027ecaa>] EFLAGS: 00010286 CPU: 0
>  >  EIP is at acpi_ps_get_next_arg+0x1b8/0x262
>  >  EAX: f7c12ec0 EBX: f7d20428 ECX: f7ca1b00 EDX: 00000001
>  >  ESI: 00000049 EDI: f7d20400 EBP: f7c61e38 ESP: c06c9dc8
>  >   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>  >  CR0: 8005003b CR2: f7c46456 CR3: 006ba000 CR4: 000006c0
>  >  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>  >  DR6: ffff4ff0 DR7: 00000400
>  >   [<c0119192>] kmemcheck_read+0xe2/0x140
>  >   [<c0119326>] kmemcheck_access+0x136/0x1a0
>  >   [<c04bd286>] do_page_fault+0x5e6/0x690
>  >   [<c04bb2da>] error_code+0x72/0x78
>  >   [<c027f991>] acpi_ps_parse_loop+0x4dd/0x7f8
>  >   [<c027ee36>] acpi_ps_parse_aml+0xb4/0x332
>  >   [<c02802c0>] acpi_ps_execute_method+0x13d/0x20d
>  >   [<c027c8a2>] acpi_ns_evaluate+0x10e/0x1b0
>  >   [<c0283210>] acpi_ut_evaluate_object+0x51/0x18d
>  >   [<c0283406>] acpi_ut_execute_STA+0x22/0x7b
>  >   [<c027c18b>] acpi_ns_get_device_callback+0x5a/0x121
>  >   [<c027e410>] acpi_ns_walk_namespace+0xf0/0x10c
>  >   [<c027c0b5>] acpi_get_devices+0x47/0x5d
>  >   [<c068db45>] pnpacpi_init+0x65/0xa0
>  >   [<c06735c7>] kernel_init+0x127/0x290
>  >   [<c0104cc7>] kernel_thread_helper+0x7/0x10
>  >   [<ffffffff>] 0xffffffff
>  >  pnp: PnP ACPI: found 17 devices
>  >  ACPI: ACPI bus type pnp unregistered
>  >
>  >  This faulting instruction comes from
>  >
>  >  $ addr2line -e vmlinux -i c027ecaa
>  >  drivers/acpi/parser/psargs.c:694
>
>  (That's some seriously hairy code in ACPI btw.)
>
>  Vegard, can you do disassembly for the faulting instruction? I *think*
>  it's the "walk_state->op" bit that is hanging to an object that was
>  already deleted in the strange loop in acpi_ps_parse_loop() but it
>  would be good to have some more data on this.

Of course. This is in fact another image, but the EIP (and indeed
EAX...EDX) are exactly the same. I hope this doesn't get mangled too
much by gmail. It's a lot, though :-)

c027eaf2 <acpi_ps_get_next_arg>:
c027eaf2:	55                   	push   %ebp
c027eaf3:	89 e5                	mov    %esp,%ebp
c027eaf5:	57                   	push   %edi
c027eaf6:	89 c7                	mov    %eax,%edi
c027eaf8:	56                   	push   %esi
c027eaf9:	89 ce                	mov    %ecx,%esi
c027eafb:	53                   	push   %ebx
c027eafc:	89 d3                	mov    %edx,%ebx
c027eafe:	8d 41 ff             	lea    -0x1(%ecx),%eax
c027eb01:	83 ec 10             	sub    $0x10,%esp
c027eb04:	83 f8 11             	cmp    $0x11,%eax
c027eb07:	0f 87 fb 01 00 00    	ja     c027ed08 <acpi_ps_get_next_arg+0x216>
c027eb0d:	ff 24 85 c4 f4 4d c0 	jmp    *-0x3fb20b3c(,%eax,4)
c027eb14:	b8 0a 00 00 00       	mov    $0xa,%eax
c027eb19:	e8 1a 15 00 00       	call   c0280038 <acpi_ps_alloc_op>
c027eb1e:	85 c0                	test   %eax,%eax
c027eb20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c027eb23:	0f 84 19 02 00 00    	je     c027ed42 <acpi_ps_get_next_arg+0x250>
c027eb29:	89 c1                	mov    %eax,%ecx
c027eb2b:	89 f2                	mov    %esi,%edx
c027eb2d:	89 d8                	mov    %ebx,%eax
c027eb2f:	e8 d8 fc ff ff       	call   c027e80c <acpi_ps_get_next_simple_arg>
c027eb34:	e9 fd 01 00 00       	jmp    c027ed36 <acpi_ps_get_next_arg+0x244>
c027eb39:	89 d0                	mov    %edx,%eax
c027eb3b:	e8 65 fc ff ff       	call   c027e7a5 <acpi_ps_get_next_package_end>
c027eb40:	89 43 10             	mov    %eax,0x10(%ebx)
c027eb43:	e9 e7 01 00 00       	jmp    c027ed2f <acpi_ps_get_next_arg+0x23d>
c027eb48:	8b 7a 04             	mov    0x4(%edx),%edi
c027eb4b:	3b 7a 10             	cmp    0x10(%edx),%edi
c027eb4e:	0f 83 db 01 00 00    	jae    c027ed2f <acpi_ps_get_next_arg+0x23d>
c027eb54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c027eb5b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c027eb62:	8b 03                	mov    (%ebx),%eax
c027eb64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c027eb67:	8a 07                	mov    (%edi),%al
c027eb69:	84 c0                	test   %al,%al
c027eb6b:	74 0c                	je     c027eb79 <acpi_ps_get_next_arg+0x87>
c027eb6d:	fe c8                	dec    %al
c027eb6f:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
c027eb75:	75 1c                	jne    c027eb93 <acpi_ps_get_next_arg+0xa1>
c027eb77:	eb 0e                	jmp    c027eb87 <acpi_ps_get_next_arg+0x95>
c027eb79:	8d 47 01             	lea    0x1(%edi),%eax
c027eb7c:	89 43 04             	mov    %eax,0x4(%ebx)
c027eb7f:	66 c7 45 ee 31 00    	movw   $0x31,-0x12(%ebp)
c027eb85:	eb 0c                	jmp    c027eb93 <acpi_ps_get_next_arg+0xa1>
c027eb87:	8d 47 01             	lea    0x1(%edi),%eax
c027eb8a:	89 43 04             	mov    %eax,0x4(%ebx)
c027eb8d:	66 c7 45 ee 32 00    	movw   $0x32,-0x12(%ebp)
c027eb93:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c027eb97:	e8 9c 14 00 00       	call   c0280038 <acpi_ps_alloc_op>
c027eb9c:	85 c0                	test   %eax,%eax
c027eb9e:	89 c6                	mov    %eax,%esi
c027eba0:	0f 84 9c 01 00 00    	je     c027ed42 <acpi_ps_get_next_arg+0x250>
c027eba6:	2b 7d f0             	sub    -0x10(%ebp),%edi
c027eba9:	89 78 08             	mov    %edi,0x8(%eax)
c027ebac:	66 83 7d ee 31       	cmpw   $0x31,-0x12(%ebp)
c027ebb1:	74 1e                	je     c027ebd1 <acpi_ps_get_next_arg+0xdf>
c027ebb3:	66 83 7d ee 32       	cmpw   $0x32,-0x12(%ebp)
c027ebb8:	74 23                	je     c027ebdd <acpi_ps_get_next_arg+0xeb>
c027ebba:	66 83 7d ee 30       	cmpw   $0x30,-0x12(%ebp)
c027ebbf:	75 47                	jne    c027ec08 <acpi_ps_get_next_arg+0x116>
c027ebc1:	8b 43 04             	mov    0x4(%ebx),%eax
c027ebc4:	8b 10                	mov    (%eax),%edx
c027ebc6:	89 f0                	mov    %esi,%eax
c027ebc8:	e8 0b 14 00 00       	call   c027ffd8 <acpi_ps_set_name>
c027ebcd:	83 43 04 04          	addl   $0x4,0x4(%ebx)
c027ebd1:	89 d8                	mov    %ebx,%eax
c027ebd3:	e8 74 fb ff ff       	call   c027e74c
<acpi_ps_get_next_package_length>
c027ebd8:	89 46 14             	mov    %eax,0x14(%esi)
c027ebdb:	eb 2b                	jmp    c027ec08 <acpi_ps_get_next_arg+0x116>
c027ebdd:	8b 43 04             	mov    0x4(%ebx),%eax
c027ebe0:	31 d2                	xor    %edx,%edx
c027ebe2:	0f b6 00             	movzbl (%eax),%eax
c027ebe5:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
c027ebec:	c1 e0 08             	shl    $0x8,%eax
c027ebef:	89 46 14             	mov    %eax,0x14(%esi)
c027ebf2:	8b 4b 04             	mov    0x4(%ebx),%ecx
c027ebf5:	8d 41 01             	lea    0x1(%ecx),%eax
c027ebf8:	89 43 04             	mov    %eax,0x4(%ebx)
c027ebfb:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
c027ebff:	09 46 14             	or     %eax,0x14(%esi)
c027ec02:	09 56 18             	or     %edx,0x18(%esi)
c027ec05:	ff 43 04             	incl   0x4(%ebx)
c027ec08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c027ec0c:	75 05                	jne    c027ec13 <acpi_ps_get_next_arg+0x121>
c027ec0e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c027ec11:	eb 06                	jmp    c027ec19 <acpi_ps_get_next_arg+0x127>
c027ec13:	8b 55 e8             	mov    -0x18(%ebp),%edx
c027ec16:	89 72 0c             	mov    %esi,0xc(%edx)
c027ec19:	8b 7b 04             	mov    0x4(%ebx),%edi
c027ec1c:	8b 43 10             	mov    0x10(%ebx),%eax
c027ec1f:	89 75 e8             	mov    %esi,-0x18(%ebp)
c027ec22:	39 c7                	cmp    %eax,%edi
c027ec24:	0f 82 38 ff ff ff    	jb     c027eb62 <acpi_ps_get_next_arg+0x70>
c027ec2a:	eb 36                	jmp    c027ec62 <acpi_ps_get_next_arg+0x170>
c027ec2c:	8b 42 04             	mov    0x4(%edx),%eax
c027ec2f:	3b 42 10             	cmp    0x10(%edx),%eax
c027ec32:	0f 83 f7 00 00 00    	jae    c027ed2f <acpi_ps_get_next_arg+0x23d>
c027ec38:	b8 33 00 00 00       	mov    $0x33,%eax
c027ec3d:	e8 f6 13 00 00       	call   c0280038 <acpi_ps_alloc_op>
c027ec42:	85 c0                	test   %eax,%eax
c027ec44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c027ec47:	0f 84 f5 00 00 00    	je     c027ed42 <acpi_ps_get_next_arg+0x250>
c027ec4d:	8b 43 10             	mov    0x10(%ebx),%eax
c027ec50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c027ec53:	2b 43 04             	sub    0x4(%ebx),%eax
c027ec56:	89 42 14             	mov    %eax,0x14(%edx)
c027ec59:	8b 43 04             	mov    0x4(%ebx),%eax
c027ec5c:	89 42 24             	mov    %eax,0x24(%edx)
c027ec5f:	8b 43 10             	mov    0x10(%ebx),%eax
c027ec62:	89 43 04             	mov    %eax,0x4(%ebx)
c027ec65:	e9 cc 00 00 00       	jmp    c027ed36 <acpi_ps_get_next_arg+0x244>
c027ec6a:	89 d0                	mov    %edx,%eax
c027ec6c:	e8 f2 00 00 00       	call   c027ed63 <acpi_ps_peek_opcode>
c027ec71:	66 85 c0             	test   %ax,%ax
c027ec74:	74 19                	je     c027ec8f <acpi_ps_get_next_arg+0x19d>
c027ec76:	0f b7 f0             	movzwl %ax,%esi
c027ec79:	89 f0                	mov    %esi,%eax
c027ec7b:	e8 29 13 00 00       	call   c027ffa9 <acpi_ps_is_leading_char>
c027ec80:	84 c0                	test   %al,%al
c027ec82:	75 0b                	jne    c027ec8f <acpi_ps_get_next_arg+0x19d>
c027ec84:	89 f0                	mov    %esi,%eax
c027ec86:	e8 37 13 00 00       	call   c027ffc2 <acpi_ps_is_prefix_char>
c027ec8b:	84 c0                	test   %al,%al
c027ec8d:	74 5f                	je     c027ecee <acpi_ps_get_next_arg+0x1fc>
c027ec8f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c027ec94:	e8 9f 13 00 00       	call   c0280038 <acpi_ps_alloc_op>
c027ec99:	85 c0                	test   %eax,%eax
c027ec9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c027ec9e:	0f 84 9e 00 00 00    	je     c027ed42 <acpi_ps_get_next_arg+0x250>
c027eca4:	8b 87 d4 01 00 00    	mov    0x1d4(%edi),%eax
c027ecaa:	66 81 78 06 2a 5b    	cmpw   $0x5b2a,0x6(%eax)

       ^--- EIP here

Well, at least kmemcheck correctly identifies it as a 16-bit read...

c027ecb0:	75 29                	jne    c027ecdb <acpi_ps_get_next_arg+0x1e9>
c027ecb2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c027ecb5:	89 da                	mov    %ebx,%edx
c027ecb7:	89 f8                	mov    %edi,%eax
c027ecb9:	6a 01                	push   $0x1
c027ecbb:	e8 2f fc ff ff       	call   c027e8ef <acpi_ps_get_next_namepath>
c027ecc0:	5f                   	pop    %edi
c027ecc1:	89 c3                	mov    %eax,%ebx
c027ecc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c027ecc6:	66 83 78 06 35       	cmpw   $0x35,0x6(%eax)
c027eccb:	75 6b                	jne    c027ed38 <acpi_ps_get_next_arg+0x246>
c027eccd:	e8 14 13 00 00       	call   c027ffe6 <acpi_ps_free_op>
c027ecd2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c027ecd9:	eb 5d                	jmp    c027ed38 <acpi_ps_get_next_arg+0x246>
c027ecdb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c027ecde:	89 da                	mov    %ebx,%edx
c027ece0:	89 f8                	mov    %edi,%eax
c027ece2:	6a 00                	push   $0x0
c027ece4:	e8 06 fc ff ff       	call   c027e8ef <acpi_ps_get_next_namepath>
c027ece9:	5e                   	pop    %esi
c027ecea:	89 c3                	mov    %eax,%ebx
c027ecec:	eb 4a                	jmp    c027ed38 <acpi_ps_get_next_arg+0x246>
c027ecee:	c7 47 54 01 00 00 00 	movl   $0x1,0x54(%edi)
c027ecf5:	eb 38                	jmp    c027ed2f <acpi_ps_get_next_arg+0x23d>
c027ecf7:	8b 42 04             	mov    0x4(%edx),%eax
c027ecfa:	3b 42 10             	cmp    0x10(%edx),%eax
c027ecfd:	73 30                	jae    c027ed2f <acpi_ps_get_next_arg+0x23d>
c027ecff:	c7 47 54 ff ff ff ff 	movl   $0xffffffff,0x54(%edi)
c027ed06:	eb 27                	jmp    c027ed2f <acpi_ps_get_next_arg+0x23d>
c027ed08:	56                   	push   %esi
c027ed09:	bb 05 30 00 00       	mov    $0x3005,%ebx
c027ed0e:	68 ce 1a 5b c0       	push   $0xc05b1ace
c027ed13:	68 e8 02 00 00       	push   $0x2e8
c027ed18:	ff 35 0c f5 4d c0    	pushl  0xc04df50c
c027ed1e:	e8 b2 4d 00 00       	call   c0283ad5 <acpi_ut_error>
c027ed23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c027ed2a:	83 c4 10             	add    $0x10,%esp
c027ed2d:	eb 09                	jmp    c027ed38 <acpi_ps_get_next_arg+0x246>
c027ed2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c027ed36:	31 db                	xor    %ebx,%ebx
c027ed38:	8b 45 08             	mov    0x8(%ebp),%eax
c027ed3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c027ed3e:	89 10                	mov    %edx,(%eax)
c027ed40:	eb 05                	jmp    c027ed47 <acpi_ps_get_next_arg+0x255>
c027ed42:	bb 04 00 00 00       	mov    $0x4,%ebx
c027ed47:	8d 65 f4             	lea    -0xc(%ebp),%esp
c027ed4a:	89 d8                	mov    %ebx,%eax
c027ed4c:	5b                   	pop    %ebx
c027ed4d:	5e                   	pop    %esi
c027ed4e:	5f                   	pop    %edi
c027ed4f:	5d                   	pop    %ebp
c027ed50:	c3                   	ret
c027ed51:	90                   	nop
c027ed52:	90                   	nop
c027ed53:	90                   	nop

Thanks! :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
