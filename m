Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYBEFj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYBEFj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYBEFjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:39:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437AbYBEFjF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:39:05 -0500
Date: Mon, 4 Feb 2008 21:39:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?Ik9saXZlciBQaW50ZXIgKFBpbnTpciBPbGl26XIpIg==?= 
	<oliver.pntr@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
Message-Id: <20080204213911.1bcbaf66.akpm@linux-foundation.org>
In-Reply-To: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 09:31:43 +0100 "Oliver Pinter (Pintér Olivér)"  <oliver.pntr@gmail.com> wrote:

> hi all!
> 
> in the 2.6.24 become i some soft lockups with usb-phone, when i pluged
> in the mobile, then the vfs-layer crashed. am afternoon can i the
> .config send, and i bisected the kernel, when i have time.
> 
> pictures from crash:
> http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/

It looks like selinux's file_has_perm() is doing spin_lock() on an
uninitialised (or already locked) spinlock.


