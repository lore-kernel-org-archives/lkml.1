Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZEIH6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZEIH6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZEIH54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:57:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38582 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZEIH5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:57:55 -0400
Date: Sat, 9 May 2009 10:00:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Tim Abbott <tabbott@mit.edu>
Subject: Minimal linker script
Message-ID: <20090509080006.GA22617@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to address the common patters in our
linker scripts I made a sketch of a minimal linker script.

As this will be the basis for my continued effort to create
a set of defines that can be used by all architectues I would like
to receive some feedback.

/*
 * Helper macros to support writing architecture specific
 * linker scripts.
 *
 * A minimal linker scripts has following content:
 *
 * OUTPUT_FORMAT(...)
 * OUTPUT_ARCH(...)
 * ENTRY(...)
 * SECTIONS
 * {
 *      . = START;
 *      __init_begin = .;
 *      HEAD_SECTION
 *      INIT_TEXT_SECTION(PAGE_SIZE)
 *      INIT_DATA_SECTION(...)
 *      PERCPU(PAGE_SIZE)
 *      __init_end = .;
 *
 *      _stext = .;
 *      TEXT_SECTION = 0
 *      _etext = .;
 *
 *      _sdata = .;
 *      RO_DATA_SECTION(PAGE_SIZE)
 *      RW_DATA_SECTION(...)
 *      _edata = .;
 *
 *      EXCEPTION_TABLE(...)
 *      NOTES
 *
 *      __bss_start = .;
 *      BSS_SECTION(0, 0)
 *      __bss_stop = .;
 *      _end = .;
 *
 *      /DISCARD/ : {
 *              EXIT_TEXT
 *              EXIT_DATA
 *              *(.exitcall.exit)
 *      }
 *      STABS_DEBUG
 *      DWARF_DEBUG
 * }
 *
 * [__init_begin, __init_end] is the init section that may be freed after init
 * [_stext, _etext] is the text section
 * [_sdata, _edata] is the data section
 *
 * Some of the included output section include their own set of constants.
 * Examples are: [__initramfs_start, __initramfs_end] for initramfs and
 *               [__nosave_begin, __nosave_end] for the nosave data
 */

There is one majot issue in the minimal script I need to address.
All symbols are absolute (__init_begin, _stext etc) - I need to find a nice
way to make them non-absolute.
For now I and more interested in comments on the structure and the coverage
of the symbols.
I strikes me that [_stext, _etext] do not cover text in the init section.
And does [_sdata, _edata] cover RO_DATA?

What abut the order of the sections - are they significant for any archtecture?
I have used an order used by some of the embedded targets that allows
a maximum of code to reside inisde [__init_begin, __init_end].

Comments appreciated!

	Sam
