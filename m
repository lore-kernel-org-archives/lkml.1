Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYBRMPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYBRMPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYBRMPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:15:02 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58775 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758226AbYBRMPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:15:00 -0500
Date: Mon, 18 Feb 2008 13:14:50 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: mm section mismatch warnings for ps3
Message-ID: <Pine.LNX.4.64.0802181309590.22124@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-67858932-1203336890=:22124"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-67858932-1203336890=:22124
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

When building current mainline for ps3_defconfig, I get the following
mm-related section mismatches:

| WARNING: mm/built-in.o(.text+0x25094): Section mismatch in reference from the function .sparse_add_one_section() to the function .meminit.text:.sparse_index_init()
| The function .sparse_add_one_section() references
| the function __meminit .sparse_index_init().
| This is often because .sparse_add_one_section lacks a __meminit 
| annotation or the annotation of .sparse_index_init is wrong.
|
| WARNING: mm/built-in.o(.text+0x25128): Section mismatch in reference from the function .sparse_add_one_section() to the function .meminit.text:.sparse_init_one_section()
| The function .sparse_add_one_section() references
| the function __meminit .sparse_init_one_section().
| This is often because .sparse_add_one_section lacks a __meminit 
| annotation or the annotation of .sparse_init_one_section is wrong.
|
| WARNING: mm/built-in.o(.text+0x2c5fc): Section mismatch in reference from the function .__add_zone() to the function .meminit.text:.init_currently_empty_zone()
| The function .__add_zone() references
| the function __meminit .init_currently_empty_zone().
| This is often because .__add_zone lacks a __meminit 
| annotation or the annotation of .init_currently_empty_zone is wrong.
|
| WARNING: mm/built-in.o(.text+0x2c628): Section mismatch in reference from the function .__add_zone() to the function .meminit.text:.memmap_init_zone()
| The function .__add_zone() references
| the function __meminit .memmap_init_zone().
| This is often because .__add_zone lacks a __meminit 
| annotation or the annotation of .memmap_init_zone is wrong.
|
| WARNING: vmlinux.o(.text+0x7360): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary()
| The function .start_secondary_prolog() references
| the function __devinit .start_secondary().
| This is often because .start_secondary_prolog lacks a __devinit 
| annotation or the annotation of .start_secondary is wrong.
|
| WARNING: vmlinux.o(.text+0x1dea0): Section mismatch in reference from the function .move_device_tree() to the function .init.text:.lmb_alloc_base()
| The function .move_device_tree() references
| the function __init .lmb_alloc_base().
| This is often because .move_device_tree lacks a __init 
| annotation or the annotation of .lmb_alloc_base is wrong.
|
| WARNING: vmlinux.o(.text+0xabd7c): Section mismatch in reference from the function .sparse_add_one_section() to the function .meminit.text:.sparse_index_init()
| The function .sparse_add_one_section() references
| the function __meminit .sparse_index_init().
| This is often because .sparse_add_one_section lacks a __meminit 
| annotation or the annotation of .sparse_index_init is wrong.
|
| WARNING: vmlinux.o(.text+0xabe10): Section mismatch in reference from the function .sparse_add_one_section() to the function .meminit.text:.sparse_init_one_section()
| The function .sparse_add_one_section() references
| the function __meminit .sparse_init_one_section().
| This is often because .sparse_add_one_section lacks a __meminit 
| annotation or the annotation of .sparse_init_one_section is wrong.
|
| WARNING: vmlinux.o(.text+0xb3198): Section mismatch in reference from the function .add_memory() to the function .devinit.text:.arch_add_memory()
| The function .add_memory() references
| the function __devinit .arch_add_memory().
| This is often because .add_memory lacks a __devinit 
| annotation or the annotation of .arch_add_memory is wrong.
|
| WARNING: vmlinux.o(.text+0xb32e4): Section mismatch in reference from the function .__add_zone() to the function .meminit.text:.init_currently_empty_zone()
| The function .__add_zone() references
| the function __meminit .init_currently_empty_zone().
| This is often because .__add_zone lacks a __meminit 
| annotation or the annotation of .init_currently_empty_zone is wrong.
|
| WARNING: vmlinux.o(.text+0xb3310): Section mismatch in reference from the function .__add_zone() to the function .meminit.text:.memmap_init_zone()
| The function .__add_zone() references
| the function __meminit .memmap_init_zone().
| This is often because .__add_zone lacks a __meminit 
| annotation or the annotation of .memmap_init_zone is wrong.

(there are a few more regarding ps3_register_repository_device(), but these
 cannot happen as only storage devices can be added later)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-67858932-1203336890=:22124--
