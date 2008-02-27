Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbYB0XkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbYB0XkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYB0XkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:40:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:14434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbYB0XkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=suBX6Cq1dlsVaTZkh0rMtOWXEGkxfPFHkTCvBhm2X6KhhUF1PKn+UZON+RUaqkxxrO1FF4EER8+y0I8FRI4kCzw64uBeN/WVP1UBLHwW4qC0dkAeaaxzf3meBt0s7+KXLZP96VDg7eQfUzpG+Ns9oODXItdPKbozXBn46Xq/o2Y=
Subject: Re: [PATCH] char: fix sparse shadowed variable warnings in
	cyclades.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080227153448.a559b6c3.akpm@linux-foundation.org>
References: <1203704055.5962.10.camel@brick>
	 <20080227153448.a559b6c3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 15:40:00 -0800
Message-Id: <1204155600.20280.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-27 at 15:34 -0800, Andrew Morton wrote:
> On Fri, 22 Feb 2008 10:14:15 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> Unrelated to your change, but...
> 
> We prefer min_t over casts like this (not sure why, but let's be consistent)
> 
> The reason for this cast is that all this code is using `int' for the
> transfer count (arguably wrong - should use size_t, but that propagates all
> the way to tty_operations.write) but cyclades has
> 
> #define SERIAL_XMIT_SIZE        (min(PAGE_SIZE, 4096))
> 
> which is unsigned on most architectures.
> 
> A possibly-sane fix for all of this is to use min_t in the above then nuke
> the casts.
> 

I'll trace this through and get you a patch.

Harvey



