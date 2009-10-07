Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZJGQJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZJGQJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZJGQJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:09:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55375 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZJGQJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:09:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Wed, 7 Oct 2009 18:10:02 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0910071157390.2762-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910071157390.2762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910071810.02966.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Oktober 2009 18:03:08 schrieb Alan Stern:
> On Wed, 7 Oct 2009, Oliver Neukum wrote:
> > We will need some generic way to autoresume from open.
> > Resume will need to lock against open() and need to be called
> > from within open(). Any ideas for an unugly interface?
>
> It's not quite that bad.  Resume doesn't need to lock against open.
> If open is called while resume is running then when it tries to do its
> own resume, it will either block (waiting for the pm_mutex) or return
> immediately (if it sees the device is already resumed).

But resume() needs to know whether the read URBs need to be
submitted or not.

	Regards
		Oliver

