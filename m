Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbYEXBIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbYEXBIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYEXBIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:08:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYEXBHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:07:54 -0400
Date: Fri, 23 May 2008 21:07:44 -0400
From: Rik van Riel <riel@redhat.com>
To: Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>
Subject: Re: [PATCH 1/2] Use structs instead of hardcoded offsets in x86
 boot decompressor.
Message-ID: <20080523210744.52fe7fde@bree.surriel.com>
In-Reply-To: <1211579968-15227-1-git-send-email-krh@redhat.com>
References: <1211579968-15227-1-git-send-email-krh@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 17:59:27 -0400
Kristian Høgsberg <krh@redhat.com> wrote:

> Signed-off-by: Kristian Høgsberg <krh@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


> +static struct boot_params *real_mode;		/* Pointer to real-mode data */
> +static struct screen_info *rm_screen_info;	/* Pointer to real-mode data */

People who wonder why these pointers never get initialized: they
point to the zeropage, which of course lives at address zero.

/* The so-called "zeropage" */
struct boot_params {
	struct screen_info screen_info;                 /* 0x000 */
        struct apm_bios_info apm_bios_info;             /* 0x040 */
        __u8  _pad2[12];                                /* 0x054 */
        struct ist_info ist_info;                       /* 0x060 */
	...

-- 
All rights reversed.
