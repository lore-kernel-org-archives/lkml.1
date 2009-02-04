Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbZBDP1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbZBDP1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZBDP1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:27:14 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:64704 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZBDP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ad9P4PFVMtwDvjkU7bD/jUS5+Bte5kAb0TGYKCAk7z3SUv2C71wfyTh1mNqiaFTT8G
         QTJs99QqTZxrJTAn2xOtTJ4Woq2GlWMU6mC7POfsBbmcJMhmZw2Ab+i8UOScGSh6jquD
         fEzBJ4pgbrchveUVs1esYXdQ94bkgHwUGBJFk=
MIME-Version: 1.0
In-Reply-To: <20090204071136.2f682dc2@infradead.org>
References: <c4e36d110902040649v3810c96du1c84caa9052ef4c6@mail.gmail.com>
	 <20090204071136.2f682dc2@infradead.org>
Date: Wed, 4 Feb 2009 16:27:08 +0100
Message-ID: <c4e36d110902040727p1742a8fbxa382cfe2cd3f0ae7@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000002328 
	__d_lookup+0xc8/0x1d0
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/4 Arjan van de Ven <arjan@infradead.org>:
> On Wed, 4 Feb 2009 15:49:52 +0100
> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>
>> Hi
>>
>> Today I've got this ugly oops - my machine T61, 4GB of memory (checked
>> with memtest), SMP, C2D
>> kernel commit: 33bfad54b58cf05cfe6678c3ec9235d4bc8db4c2
>>
>> The only 'strange' thing I've been doing today is testing ext4 and its
>> online resize functionality.
>> But this oops happened somewhat later - so I'm not really sure whether
>> there is some correlation.
>>
>> (Full kernel log follows)
>
> if you have CONFIG_DEBUG_INFO enabled, you can run the oops through
> http://www.kerneloops.org/download/markup_oops.pl (or
> scripts/markup_oops.pl, but the 64 bit support is pending in a
> maintainer tree) to turn this into an even better bug report...
> ... it will show exactly where in the code the oops was.
>

Yep ok - I'm using a script called disasfun.sh - but both gives the same output:

--------------
Here is markup_oops.pl:
---------------

No vmlinux specified, assuming /lib/modules/2.6.29-rc3/build/vmlinux
 				goto next;
 		} else {
 			if (qstr->len != len)
 				goto next;
 			if (memcmp(qstr->name, str, len))
 ffffffff802f821b:	44 8b 75 c4          	mov    -0x3c(%rbp),%r14d |  %r14 => 5
 	struct hlist_node *node;
 	struct dentry *dentry;

 	rcu_read_lock();
 	
 	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
 ffffffff802f821f:	4c 31 eb             	xor    %r13,%rbx   |  %r13 =
18721e0036d5fe5
 ffffffff802f8222:	44 8b 55 b8          	mov    -0x48(%rbp),%r10d |
%r10 => 85a6ed9
 ffffffff802f8226:	41 21 dc             	and    %ebx,%r12d
 ffffffff802f8229:	4c 8b 5d b0          	mov    -0x50(%rbp),%r11 |
%r11 => ffff88013b404300
 ffffffff802f822d:	4e 8d 24 e0          	lea    (%rax,%r12,8),%r12 |
%r12 => ffff8800028b0000
 ffffffff802f8231:	49 8b 04 24          	mov    (%r12),%rax |  %r12 =
ffff8800028b0000
 ffffffff802f8235:	48 89 c3             	mov    %rax,%rbx
 ffffffff802f8238:	48 85 c0             	test   %rax,%rax   |  %eax => 2328
 ffffffff802f823b:	75 0b                	jne    ffffffff802f8248
<__d_lookup+0xc8>
 ffffffff802f823d:	eb 69                	jmp    ffffffff802f82a8
<__d_lookup+0x128>
 ffffffff802f823f:	90                   	nop
 ffffffff802f8240:	48 8b 1b             	mov    (%rbx),%rbx
 ffffffff802f8243:	48 85 db             	test   %rbx,%rbx   |  %ebx => 2328
 ffffffff802f8246:	74 60                	je     ffffffff802f82a8
<__d_lookup+0x128>
*ffffffff802f8248:	48 8b 03             	mov    (%rbx),%rax |  %ebx =
2328 <--- faulting instruction
 ffffffff802f824b:	4c 8d 63 a8          	lea    -0x58(%rbx),%r12
 ffffffff802f824f:	0f 18 08             	prefetcht0 (%rax)
 		struct qstr *qstr;

 		if (dentry->d_name.hash != hash)
 ffffffff802f8252:	45 39 54 24 70       	cmp    %r10d,0x70(%r12)
 ffffffff802f8257:	75 e7                	jne    ffffffff802f8240
<__d_lookup+0xc0>
 			continue;
 		if (dentry->d_parent != parent)
 ffffffff802f8259:	4d 39 5c 24 68       	cmp    %r11,0x68(%r12)
 ffffffff802f825e:	75 e0                	jne    ffffffff802f8240
<__d_lookup+0xc0>
 			continue;

 		spin_lock(&dentry->d_lock);
 ffffffff802f8260:	44 89 55 b8          	mov    %r10d,-0x48(%rbp)
 ffffffff802f8264:	4c 89 5d b0          	mov    %r11,-0x50(%rbp)
 ffffffff802f8268:	4d 8d 6c 24 08       	lea    0x8(%r12),%r13
 ffffffff802f826d:	4c 89 ef             	mov    %r13,%rdi
 ffffffff802f8270:	e8 3b df 25 00       	callq  ffffffff805561b0 <_spin_lock>
 		/*
 		 * Recheck the dentry after taking the lock - d_move may have


--------------------------
and here is  disasfun.sh  -   fault is at 0x2100 + 0xc8 -> 0x21c8
---------------------------



    2191:	44 89 f1             	mov    %r14d,%ecx
	struct hlist_node *node;
	struct dentry *dentry;

	rcu_read_lock();
	
	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
    2194:	48 8b 45 d0          	mov    -0x30(%rbp),%rax

static inline struct hlist_head *d_hash(struct dentry *parent,
					unsigned long hash)
{
	hash += ((unsigned long) parent ^ GOLDEN_RATIO_PRIME) / L1_CACHE_BYTES;
	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> D_HASHBITS);
    2198:	48 d3 eb             	shr    %cl,%rbx
			if (parent->d_op->d_compare(parent, qstr, name))
				goto next;
		} else {
			if (qstr->len != len)
				goto next;
			if (memcmp(qstr->name, str, len))
    219b:	44 8b 75 c4          	mov    -0x3c(%rbp),%r14d
	struct hlist_node *node;
	struct dentry *dentry;

	rcu_read_lock();
	
	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
    219f:	4c 31 eb             	xor    %r13,%rbx
    21a2:	44 8b 55 b8          	mov    -0x48(%rbp),%r10d
    21a6:	41 21 dc             	and    %ebx,%r12d
    21a9:	4c 8b 5d b0          	mov    -0x50(%rbp),%r11
    21ad:	4e 8d 24 e0          	lea    (%rax,%r12,8),%r12
    21b1:	49 8b 04 24          	mov    (%r12),%rax
    21b5:	48 89 c3             	mov    %rax,%rbx
    21b8:	48 85 c0             	test   %rax,%rax
    21bb:	75 0b                	jne    21c8 <__d_lookup+0xc8>
    21bd:	eb 69                	jmp    2228 <__d_lookup+0x128>
    21bf:	90                   	nop
    21c0:	48 8b 1b             	mov    (%rbx),%rbx
    21c3:	48 85 db             	test   %rbx,%rbx
    21c6:	74 60                	je     2228 <__d_lookup+0x128>
    21c8:	48 8b 03             	mov    (%rbx),%rax
    21cb:	4c 8d 63 a8          	lea    -0x58(%rbx),%r12
    21cf:	0f 18 08             	prefetcht0 (%rax)
		struct qstr *qstr;

		if (dentry->d_name.hash != hash)
    21d2:	45 39 54 24 70       	cmp    %r10d,0x70(%r12)
    21d7:	75 e7                	jne    21c0 <__d_lookup+0xc0>
			continue;
		if (dentry->d_parent != parent)
    21d9:	4d 39 5c 24 68       	cmp    %r11,0x68(%r12)
    21de:	75 e0                	jne    21c0 <__d_lookup+0xc0>
			continue;

		spin_lock(&dentry->d_lock);
    21e0:	44 89 55 b8          	mov    %r10d,-0x48(%rbp)
    21e4:	4c 89 5d b0          	mov    %r11,-0x50(%rbp)
    21e8:	4d 8d 6c 24 08       	lea    0x8(%r12),%r13
    21ed:	4c 89 ef             	mov    %r13,%rdi
    21f0:	e8 00 00 00 00       	callq  21f5 <__d_lookup+0xf5>
		/*
		 * Recheck the dentry after taking the lock - d_move may have
		 * changed things.  Don't bother checking the hash because we're
		 * about to compare the whole name anyway.
		 */
		if (dentry->d_parent != parent)


Zdenek
