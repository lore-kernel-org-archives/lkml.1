Return-Path: <linux-kernel-owner+w=401wt.eu-S964965AbXBUONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965AbXBUONz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161244AbXBUONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:13:55 -0500
Received: from lmv.inov.pt ([146.193.64.2]:58978 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965AbXBUONy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:13:54 -0500
Message-ID: <45DC537B.6020108@inov.pt>
Date: Wed, 21 Feb 2007 14:13:15 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk>
In-Reply-To: <20070219212347.GA4258@flint.arm.linux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------060504000908020305040100"
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060504000908020305040100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

New devolpments.
I have upgraded to 2.6.16.41, applied a patch sent by Frederik that
removed the changed made in http://lkml.org/lkml/2005/6/23/266 and
activated some more kernel debug, i.e., CONFIG_KALLSYMS_ALL,
CONFIG_DEBUG_KERNEL, CONFIG_DETECT_SOFTLOCKUP, CONFIG_DEBUG_SLAB,
CONFIG_DEBUG_MUTEXES, CONFIG_FRAME_POINTER and CONFIG_FORCED_INLINING
(thanks to vda for pointing me to the right doc.).
At first it seemed to work fine, but after some days of continuous
running I've got another kernel Oops!
I attach the dmesg output and the assembly dump of serial8250_startup()
and serial8250_shutdown().

Regards,
José Gonçalves


--------------060504000908020305040100
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

<1>[18840.304048] Unable to handle kernel NULL pointer dereference at virtual address 00000012
<1>[18840.313046]  printing eip:
<4>[18840.321687] c01bfa7a
<1>[18840.321714] *pde = 00000000
<0>[18840.331287] Oops: 0000 [#1]
<4>[18840.340687] Modules linked in:
<0>[18840.349749] CPU:    0
<4>[18840.349767] EIP:    0060:[<c01bfa7a>]    Not tainted VLI
<4>[18840.349782] EFLAGS: 00010202   (2.6.16.41-mtm5-debug1 #1) 
<0>[18840.377277] EIP is at serial_in+0xa/0x4a
<0>[18840.387221] eax: 00000060   ebx: 00000000   ecx: 00000000   edx: 00000000
<0>[18840.397805] esi: 00000000   edi: 00000040   ebp: c728fe1c   esp: c728fe18
<0>[18840.408579] ds: 007b   es: 007b   ss: 0068
<0>[18840.419624] Process gp_position (pid: 11629, threadinfo=c728e000 task=c7443a90)
<0>[18840.420509] Stack: <0>00000000 00000000 c01c0f88 00000000 00000000 c031fef0 00000005 00000202 
<0>[18840.445655]        c7161a1c c031fef0 c124b510 c728fe60 c01bd97d c031fef0 c124b510 c124b510 
<0>[18840.460540]        00000000 c773dbcc c728fe7c c01befe7 c124b510 00000000 ffffffed c773dbcc 
<0>[18840.475892] Call Trace:
<0>[18840.490039]  [<c0102a35>] show_stack_log_lvl+0xa5/0xad
<0>[18840.504944]  [<c0102b70>] show_registers+0x106/0x16f
<0>[18840.520104]  [<c0102d06>] die+0xb6/0x127
<0>[18840.535497]  [<c0109677>] do_page_fault+0x380/0x4b3
<0>[18840.550828]  [<c01026bf>] error_code+0x4f/0x60
<0>[18840.566645]  [<c01c0f88>] serial8250_startup+0x28f/0x2a9
<0>[18840.582471] Code: 38 43 78 75 02 b2 01 89 d0 eb 10 8b 41 70 39 43 70 0f 94 c0 0f b6 c0 eb 02 31 c0 5b 5d c3 90 90 90 55 89 e5 53 8b 5d 08 8b 55 0c <0f> b6 4b 12 0f b6 43 13 d3 e2 83 f8 02 74 1a 7f 05 48 74 09 eb 
<4>[18840.680471]  BUG: gp_position/11629, lock held at task exit time!
<4>[18840.702808]  [c124b528] {uart_register_driver}
<4>[18840.722346] .. held by:       gp_position:11629 [c7443a90, 117]
<4>[18840.742113] ... acquired at:               uart_get+0x28/0xde

--------------060504000908020305040100
Content-Type: text/plain;
 name="objdump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="objdump.txt"


vmlinux-2.6.16.41-mtm5-debug1:     file format elf32-i386

Disassembly of section .text:

c01c0cf9 <serial8250_startup>:
c01c0cf9:	55                   	push   %ebp
c01c0cfa:	89 e5                	mov    %esp,%ebp
c01c0cfc:	57                   	push   %edi
c01c0cfd:	56                   	push   %esi
c01c0cfe:	53                   	push   %ebx
c01c0cff:	53                   	push   %ebx
c01c0d00:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01c0d03:	8b 43 60             	mov    0x60(%ebx),%eax
c01c0d06:	c6 83 a7 00 00 00 00 	movb   $0x0,0xa7(%ebx)
c01c0d0d:	89 c2                	mov    %eax,%edx
c01c0d0f:	c1 e2 04             	shl    $0x4,%edx
c01c0d12:	83 f8 0a             	cmp    $0xa,%eax
c01c0d15:	8b 92 ac 37 25 c0    	mov    0xc02537ac(%edx),%edx
c01c0d1b:	66 89 93 9c 00 00 00 	mov    %dx,0x9c(%ebx)
c01c0d22:	75 66                	jne    c01c0d8a <serial8250_startup+0x91>
c01c0d24:	c6 83 a4 00 00 00 00 	movb   $0x0,0xa4(%ebx)
c01c0d2b:	68 bf 00 00 00       	push   $0xbf
c01c0d30:	6a 03                	push   $0x3
c01c0d32:	53                   	push   %ebx
c01c0d33:	e8 82 ed ff ff       	call   c01bfaba <serial_out>
c01c0d38:	6a 10                	push   $0x10
c01c0d3a:	6a 02                	push   $0x2
c01c0d3c:	53                   	push   %ebx
c01c0d3d:	e8 78 ed ff ff       	call   c01bfaba <serial_out>
c01c0d42:	6a 00                	push   $0x0
c01c0d44:	6a 01                	push   $0x1
c01c0d46:	53                   	push   %ebx
c01c0d47:	e8 6e ed ff ff       	call   c01bfaba <serial_out>
c01c0d4c:	83 c4 24             	add    $0x24,%esp
c01c0d4f:	6a 00                	push   $0x0
c01c0d51:	6a 03                	push   $0x3
c01c0d53:	53                   	push   %ebx
c01c0d54:	e8 61 ed ff ff       	call   c01bfaba <serial_out>
c01c0d59:	6a 00                	push   $0x0
c01c0d5b:	6a 0c                	push   $0xc
c01c0d5d:	53                   	push   %ebx
c01c0d5e:	e8 a7 ed ff ff       	call   c01bfb0a <serial_icr_write>
c01c0d63:	68 bf 00 00 00       	push   $0xbf
c01c0d68:	6a 03                	push   $0x3
c01c0d6a:	53                   	push   %ebx
c01c0d6b:	e8 4a ed ff ff       	call   c01bfaba <serial_out>
c01c0d70:	83 c4 24             	add    $0x24,%esp
c01c0d73:	6a 10                	push   $0x10
c01c0d75:	6a 02                	push   $0x2
c01c0d77:	53                   	push   %ebx
c01c0d78:	e8 3d ed ff ff       	call   c01bfaba <serial_out>
c01c0d7d:	6a 00                	push   $0x0
c01c0d7f:	6a 03                	push   $0x3
c01c0d81:	53                   	push   %ebx
c01c0d82:	e8 33 ed ff ff       	call   c01bfaba <serial_out>
c01c0d87:	83 c4 18             	add    $0x18,%esp
c01c0d8a:	f6 83 9d 00 00 00 01 	testb  $0x1,0x9d(%ebx)
c01c0d91:	74 27                	je     c01c0dba <serial8250_startup+0xc1>
c01c0d93:	6a 01                	push   $0x1
c01c0d95:	6a 02                	push   $0x2
c01c0d97:	53                   	push   %ebx
c01c0d98:	e8 1d ed ff ff       	call   c01bfaba <serial_out>
c01c0d9d:	83 c4 0c             	add    $0xc,%esp
c01c0da0:	6a 07                	push   $0x7
c01c0da2:	6a 02                	push   $0x2
c01c0da4:	53                   	push   %ebx
c01c0da5:	e8 10 ed ff ff       	call   c01bfaba <serial_out>
c01c0daa:	83 c4 0c             	add    $0xc,%esp
c01c0dad:	6a 00                	push   $0x0
c01c0daf:	6a 02                	push   $0x2
c01c0db1:	53                   	push   %ebx
c01c0db2:	e8 03 ed ff ff       	call   c01bfaba <serial_out>
c01c0db7:	83 c4 0c             	add    $0xc,%esp
c01c0dba:	6a 05                	push   $0x5
c01c0dbc:	53                   	push   %ebx
c01c0dbd:	e8 ae ec ff ff       	call   c01bfa70 <serial_in>
c01c0dc2:	6a 00                	push   $0x0
c01c0dc4:	53                   	push   %ebx
c01c0dc5:	e8 a6 ec ff ff       	call   c01bfa70 <serial_in>
c01c0dca:	6a 02                	push   $0x2
c01c0dcc:	53                   	push   %ebx
c01c0dcd:	e8 9e ec ff ff       	call   c01bfa70 <serial_in>
c01c0dd2:	6a 06                	push   $0x6
c01c0dd4:	53                   	push   %ebx
c01c0dd5:	e8 96 ec ff ff       	call   c01bfa70 <serial_in>
c01c0dda:	83 c4 20             	add    $0x20,%esp
c01c0ddd:	f6 43 55 40          	testb  $0x40,0x55(%ebx)
c01c0de1:	75 28                	jne    c01c0e0b <serial8250_startup+0x112>
c01c0de3:	6a 05                	push   $0x5
c01c0de5:	53                   	push   %ebx
c01c0de6:	e8 85 ec ff ff       	call   c01bfa70 <serial_in>
c01c0deb:	5a                   	pop    %edx
c01c0dec:	3d ff 00 00 00       	cmp    $0xff,%eax
c01c0df1:	59                   	pop    %ecx
c01c0df2:	75 17                	jne    c01c0e0b <serial8250_startup+0x112>
c01c0df4:	ff 73 6c             	pushl  0x6c(%ebx)
c01c0df7:	68 fb 4e 26 c0       	push   $0xc0264efb
c01c0dfc:	e8 5c cd f4 ff       	call   c010db5d <printk>
c01c0e01:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
c01c0e06:	e9 8f 01 00 00       	jmp    c01c0f9a <serial8250_startup+0x2a1>
c01c0e0b:	83 7b 60 0c          	cmpl   $0xc,0x60(%ebx)
c01c0e0f:	75 61                	jne    c01c0e72 <serial8250_startup+0x179>
c01c0e11:	68 bf 00 00 00       	push   $0xbf
c01c0e16:	6a 03                	push   $0x3
c01c0e18:	53                   	push   %ebx
c01c0e19:	e8 9c ec ff ff       	call   c01bfaba <serial_out>
c01c0e1e:	6a 01                	push   $0x1
c01c0e20:	53                   	push   %ebx
c01c0e21:	e8 4a ec ff ff       	call   c01bfa70 <serial_in>
c01c0e26:	83 e0 7f             	and    $0x7f,%eax
c01c0e29:	89 c6                	mov    %eax,%esi
c01c0e2b:	83 c8 30             	or     $0x30,%eax
c01c0e2e:	0f b6 c0             	movzbl %al,%eax
c01c0e31:	50                   	push   %eax
c01c0e32:	6a 01                	push   $0x1
c01c0e34:	53                   	push   %ebx
c01c0e35:	e8 80 ec ff ff       	call   c01bfaba <serial_out>
c01c0e3a:	83 c4 20             	add    $0x20,%esp
c01c0e3d:	83 ce b0             	or     $0xffffffb0,%esi
c01c0e40:	6a 60                	push   $0x60
c01c0e42:	6a 00                	push   $0x0
c01c0e44:	53                   	push   %ebx
c01c0e45:	e8 70 ec ff ff       	call   c01bfaba <serial_out>
c01c0e4a:	89 f2                	mov    %esi,%edx
c01c0e4c:	0f b6 c2             	movzbl %dl,%eax
c01c0e4f:	50                   	push   %eax
c01c0e50:	6a 01                	push   $0x1
c01c0e52:	53                   	push   %ebx
c01c0e53:	e8 62 ec ff ff       	call   c01bfaba <serial_out>
c01c0e58:	6a 60                	push   $0x60
c01c0e5a:	6a 00                	push   $0x0
c01c0e5c:	53                   	push   %ebx
c01c0e5d:	e8 58 ec ff ff       	call   c01bfaba <serial_out>
c01c0e62:	83 c4 24             	add    $0x24,%esp
c01c0e65:	6a 00                	push   $0x0
c01c0e67:	6a 03                	push   $0x3
c01c0e69:	53                   	push   %ebx
c01c0e6a:	e8 4b ec ff ff       	call   c01bfaba <serial_out>
c01c0e6f:	83 c4 0c             	add    $0xc,%esp
c01c0e72:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c01c0e76:	75 2d                	jne    c01c0ea5 <serial8250_startup+0x1ac>
c01c0e78:	8b 43 5c             	mov    0x5c(%ebx),%eax
c01c0e7b:	ba 01 00 00 00       	mov    $0x1,%edx
c01c0e80:	83 f8 06             	cmp    $0x6,%eax
c01c0e83:	76 05                	jbe    c01c0e8a <serial8250_startup+0x191>
c01c0e85:	d1 e8                	shr    %eax
c01c0e87:	8d 50 fe             	lea    0xfffffffe(%eax),%edx
c01c0e8a:	89 9b 8c 00 00 00    	mov    %ebx,0x8c(%ebx)
c01c0e90:	a1 38 98 28 c0       	mov    0xc0289838,%eax
c01c0e95:	01 d0                	add    %edx,%eax
c01c0e97:	50                   	push   %eax
c01c0e98:	8d 43 7c             	lea    0x7c(%ebx),%eax
c01c0e9b:	50                   	push   %eax
c01c0e9c:	e8 8f 2d f5 ff       	call   c0113c30 <mod_timer>
c01c0ea1:	5f                   	pop    %edi
c01c0ea2:	58                   	pop    %eax
c01c0ea3:	eb 0f                	jmp    c01c0eb4 <serial8250_startup+0x1bb>
c01c0ea5:	53                   	push   %ebx
c01c0ea6:	e8 2e fc ff ff       	call   c01c0ad9 <serial_link_irq_chain>
c01c0eab:	5e                   	pop    %esi
c01c0eac:	85 c0                	test   %eax,%eax
c01c0eae:	0f 85 e6 00 00 00    	jne    c01c0f9a <serial8250_startup+0x2a1>
c01c0eb4:	6a 03                	push   $0x3
c01c0eb6:	6a 03                	push   $0x3
c01c0eb8:	53                   	push   %ebx
c01c0eb9:	e8 fc eb ff ff       	call   c01bfaba <serial_out>
c01c0ebe:	9c                   	pushf  
c01c0ebf:	8f 45 f0             	popl   0xfffffff0(%ebp)
c01c0ec2:	fa                   	cli    
c01c0ec3:	83 c4 0c             	add    $0xc,%esp
c01c0ec6:	8b 43 08             	mov    0x8(%ebx),%eax
c01c0ec9:	f6 43 54 02          	testb  $0x2,0x54(%ebx)
c01c0ecd:	74 0d                	je     c01c0edc <serial8250_startup+0x1e3>
c01c0ecf:	85 c0                	test   %eax,%eax
c01c0ed1:	75 14                	jne    c01c0ee7 <serial8250_startup+0x1ee>
c01c0ed3:	81 4b 58 00 20 00 00 	orl    $0x2000,0x58(%ebx)
c01c0eda:	eb 0b                	jmp    c01c0ee7 <serial8250_startup+0x1ee>
c01c0edc:	85 c0                	test   %eax,%eax
c01c0ede:	74 07                	je     c01c0ee7 <serial8250_startup+0x1ee>
c01c0ee0:	81 4b 58 00 40 00 00 	orl    $0x4000,0x58(%ebx)
c01c0ee7:	ff 73 58             	pushl  0x58(%ebx)
c01c0eea:	53                   	push   %ebx
c01c0eeb:	e8 7a fd ff ff       	call   c01c0c6a <serial8250_set_mctrl>
c01c0ef0:	6a 02                	push   $0x2
c01c0ef2:	6a 01                	push   $0x1
c01c0ef4:	53                   	push   %ebx
c01c0ef5:	e8 c0 eb ff ff       	call   c01bfaba <serial_out>
c01c0efa:	6a 05                	push   $0x5
c01c0efc:	53                   	push   %ebx
c01c0efd:	e8 6e eb ff ff       	call   c01bfa70 <serial_in>
c01c0f02:	89 c7                	mov    %eax,%edi
c01c0f04:	6a 02                	push   $0x2
c01c0f06:	53                   	push   %ebx
c01c0f07:	e8 64 eb ff ff       	call   c01bfa70 <serial_in>
c01c0f0c:	83 c4 24             	add    $0x24,%esp
c01c0f0f:	89 c6                	mov    %eax,%esi
c01c0f11:	6a 00                	push   $0x0
c01c0f13:	6a 01                	push   $0x1
c01c0f15:	53                   	push   %ebx
c01c0f16:	e8 9f eb ff ff       	call   c01bfaba <serial_out>
c01c0f1b:	83 c4 0c             	add    $0xc,%esp
c01c0f1e:	83 e7 40             	and    $0x40,%edi
c01c0f21:	74 1c                	je     c01c0f3f <serial8250_startup+0x246>
c01c0f23:	83 e6 01             	and    $0x1,%esi
c01c0f26:	74 17                	je     c01c0f3f <serial8250_startup+0x246>
c01c0f28:	66 8b 83 9e 00 00 00 	mov    0x9e(%ebx),%ax
c01c0f2f:	a8 02                	test   $0x2,%al
c01c0f31:	75 14                	jne    c01c0f47 <serial8250_startup+0x24e>
c01c0f33:	83 c8 02             	or     $0x2,%eax
c01c0f36:	66 89 83 9e 00 00 00 	mov    %ax,0x9e(%ebx)
c01c0f3d:	eb 08                	jmp    c01c0f47 <serial8250_startup+0x24e>
c01c0f3f:	66 83 a3 9e 00 00 00 	andw   $0xfffffffd,0x9e(%ebx)
c01c0f46:	fd 
c01c0f47:	ff 75 f0             	pushl  0xfffffff0(%ebp)
c01c0f4a:	9d                   	popf   
c01c0f4b:	c6 83 a5 00 00 00 05 	movb   $0x5,0xa5(%ebx)
c01c0f52:	6a 05                	push   $0x5
c01c0f54:	6a 01                	push   $0x1
c01c0f56:	53                   	push   %ebx
c01c0f57:	e8 5e eb ff ff       	call   c01bfaba <serial_out>
c01c0f5c:	83 c4 0c             	add    $0xc,%esp
c01c0f5f:	f6 43 54 02          	testb  $0x2,0x54(%ebx)
c01c0f63:	74 13                	je     c01c0f78 <serial8250_startup+0x27f>
c01c0f65:	8b 13                	mov    (%ebx),%edx
c01c0f67:	b0 80                	mov    $0x80,%al
c01c0f69:	81 e2 e0 0f 00 00    	and    $0xfe0,%edx
c01c0f6f:	83 ca 1f             	or     $0x1f,%edx
c01c0f72:	ee                   	out    %al,(%dx)
c01c0f73:	e6 80                	out    %al,$0x80
c01c0f75:	ec                   	in     (%dx),%al
c01c0f76:	e6 80                	out    %al,$0x80
c01c0f78:	6a 05                	push   $0x5
c01c0f7a:	53                   	push   %ebx
c01c0f7b:	e8 f0 ea ff ff       	call   c01bfa70 <serial_in>
c01c0f80:	6a 00                	push   $0x0
c01c0f82:	53                   	push   %ebx
c01c0f83:	e8 e8 ea ff ff       	call   c01bfa70 <serial_in>
c01c0f88:	6a 02                	push   $0x2
c01c0f8a:	53                   	push   %ebx
c01c0f8b:	e8 e0 ea ff ff       	call   c01bfa70 <serial_in>
c01c0f90:	6a 06                	push   $0x6
c01c0f92:	53                   	push   %ebx
c01c0f93:	e8 d8 ea ff ff       	call   c01bfa70 <serial_in>
c01c0f98:	31 c0                	xor    %eax,%eax
c01c0f9a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
c01c0f9d:	5b                   	pop    %ebx
c01c0f9e:	5e                   	pop    %esi
c01c0f9f:	5f                   	pop    %edi
c01c0fa0:	5d                   	pop    %ebp
c01c0fa1:	c3                   	ret    

c01c0fa2 <serial8250_shutdown>:
c01c0fa2:	55                   	push   %ebp
c01c0fa3:	89 e5                	mov    %esp,%ebp
c01c0fa5:	56                   	push   %esi
c01c0fa6:	53                   	push   %ebx
c01c0fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01c0faa:	c6 83 a5 00 00 00 00 	movb   $0x0,0xa5(%ebx)
c01c0fb1:	6a 00                	push   $0x0
c01c0fb3:	6a 01                	push   $0x1
c01c0fb5:	53                   	push   %ebx
c01c0fb6:	e8 ff ea ff ff       	call   c01bfaba <serial_out>
c01c0fbb:	9c                   	pushf  
c01c0fbc:	5e                   	pop    %esi
c01c0fbd:	fa                   	cli    
c01c0fbe:	83 c4 0c             	add    $0xc,%esp
c01c0fc1:	8b 4b 58             	mov    0x58(%ebx),%ecx
c01c0fc4:	f6 43 54 02          	testb  $0x2,0x54(%ebx)
c01c0fc8:	74 11                	je     c01c0fdb <serial8250_shutdown+0x39>
c01c0fca:	8b 13                	mov    (%ebx),%edx
c01c0fcc:	81 e2 e0 0f 00 00    	and    $0xfe0,%edx
c01c0fd2:	83 ca 1f             	or     $0x1f,%edx
c01c0fd5:	ec                   	in     (%dx),%al
c01c0fd6:	80 cd 20             	or     $0x20,%ch
c01c0fd9:	eb 03                	jmp    c01c0fde <serial8250_shutdown+0x3c>
c01c0fdb:	80 e5 bf             	and    $0xbf,%ch
c01c0fde:	89 4b 58             	mov    %ecx,0x58(%ebx)
c01c0fe1:	ff 73 58             	pushl  0x58(%ebx)
c01c0fe4:	53                   	push   %ebx
c01c0fe5:	e8 80 fc ff ff       	call   c01c0c6a <serial8250_set_mctrl>
c01c0fea:	58                   	pop    %eax
c01c0feb:	5a                   	pop    %edx
c01c0fec:	56                   	push   %esi
c01c0fed:	9d                   	popf   
c01c0fee:	6a 03                	push   $0x3
c01c0ff0:	53                   	push   %ebx
c01c0ff1:	e8 7a ea ff ff       	call   c01bfa70 <serial_in>
c01c0ff6:	83 e0 bf             	and    $0xffffffbf,%eax
c01c0ff9:	59                   	pop    %ecx
c01c0ffa:	5e                   	pop    %esi
c01c0ffb:	50                   	push   %eax
c01c0ffc:	6a 03                	push   $0x3
c01c0ffe:	53                   	push   %ebx
c01c0fff:	e8 b6 ea ff ff       	call   c01bfaba <serial_out>
c01c1004:	83 c4 0c             	add    $0xc,%esp
c01c1007:	f6 83 9d 00 00 00 01 	testb  $0x1,0x9d(%ebx)
c01c100e:	74 27                	je     c01c1037 <serial8250_shutdown+0x95>
c01c1010:	6a 01                	push   $0x1
c01c1012:	6a 02                	push   $0x2
c01c1014:	53                   	push   %ebx
c01c1015:	e8 a0 ea ff ff       	call   c01bfaba <serial_out>
c01c101a:	83 c4 0c             	add    $0xc,%esp
c01c101d:	6a 07                	push   $0x7
c01c101f:	6a 02                	push   $0x2
c01c1021:	53                   	push   %ebx
c01c1022:	e8 93 ea ff ff       	call   c01bfaba <serial_out>
c01c1027:	83 c4 0c             	add    $0xc,%esp
c01c102a:	6a 00                	push   $0x0
c01c102c:	6a 02                	push   $0x2
c01c102e:	53                   	push   %ebx
c01c102f:	e8 86 ea ff ff       	call   c01bfaba <serial_out>
c01c1034:	83 c4 0c             	add    $0xc,%esp
c01c1037:	6a 00                	push   $0x0
c01c1039:	53                   	push   %ebx
c01c103a:	e8 31 ea ff ff       	call   c01bfa70 <serial_in>
c01c103f:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c01c1043:	58                   	pop    %eax
c01c1044:	5a                   	pop    %edx
c01c1045:	75 0b                	jne    c01c1052 <serial8250_shutdown+0xb0>
c01c1047:	8d 43 7c             	lea    0x7c(%ebx),%eax
c01c104a:	50                   	push   %eax
c01c104b:	e8 09 2c f5 ff       	call   c0113c59 <del_timer>
c01c1050:	eb 06                	jmp    c01c1058 <serial8250_shutdown+0xb6>
c01c1052:	53                   	push   %ebx
c01c1053:	e8 14 fb ff ff       	call   c01c0b6c <serial_unlink_irq_chain>
c01c1058:	5e                   	pop    %esi
c01c1059:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
c01c105c:	5b                   	pop    %ebx
c01c105d:	5e                   	pop    %esi
c01c105e:	5d                   	pop    %ebp
c01c105f:	c3                   	ret    
Disassembly of section .init.text:
Disassembly of section .altinstr_replacement:
Disassembly of section .exit.text:

--------------060504000908020305040100--
