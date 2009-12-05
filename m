Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbZLEBbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbZLEBbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932727AbZLEBbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:31:41 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:34905 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbZLEBbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:31:40 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 05/24] ceph: ref counted buffer
Date: Sat, 5 Dec 2009 02:31:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1259883691-1042-1-git-send-email-sage@newdream.net> <1259883691-1042-5-git-send-email-sage@newdream.net> <1259883691-1042-6-git-send-email-sage@newdream.net>
In-Reply-To: <1259883691-1042-6-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912050231.23530.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009, Sage Weil wrote:
> struct ceph_buffer is a simple ref-counted buffer.  We transparently
> choose between kmalloc for small buffers and vmalloc for large ones.
> 
> This is currently used only for allocating memory for xattr data.

Could you wrap parts of this refcounting logic around kref?
see #include <linux/kref.h> and lib/kref.c

It avoids a bug with memory areas for free and if anybody
optimizes or changes refcounting stuff, you get all changes for free :-)

Best Regards

Ingo Oeser
