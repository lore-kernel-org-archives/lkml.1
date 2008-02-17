Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYBQKvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYBQKvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYBQKvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:51:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:1213 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYBQKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=YhFEa2Wm+C3jmmWrOOj8MFpMEM1OocUyAdxlXZdd2c9LKDIFtFO+IVQiRyyJVBWp8mmb2Iacg3B9Ynwb+81yrr58Km51VtBJWOeBQwEcEKx4vszEqvnsgNeoSGu1UPAHDAc2eEbnKY0aAzgWK55DZ6CJy75VCy0XD83KsL+6jIg=
Date: Sun, 17 Feb 2008 13:50:50 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, alexn@dsv.su.se,
       dwalker@mvista.com
Subject: 2.6.25-rc2-mm1: new create_proc_entry() users
Message-ID: <20080217105050.GC6596@martell.zuzino.mipt.ru>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> profile-likely-unlikely-macros
> page-owner-tracking-leak-detector
> cciss-procfs-updates-to-display-info-about-many-volumes

Guys, create_proc_entry() is slightly racy in case of modular code and
proc_create() was invented to fix it. Eventually all create_proc_entry()
users will be converted to proc_create(), so please do it for new code.
