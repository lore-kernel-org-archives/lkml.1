Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab0BZIDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:03:38 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:49417 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZIDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:03:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lhTG8QOb65f0BpIsCnjvCr+jeCD8ob8M0JVFSs5d6bbyBAeUAGpvPZNKeMogsVNfbS
         /eHLSKJZvI1rC5LrNj6e3LVhXhXcYKsjbOc0VkThOaFcmJfWU8FmvhNJ8Foof0E94GQe
         R+tAD+9Zcf5r/NAMvLsFI2/05dIjfZY6GKyHg=
Date: Fri, 26 Feb 2010 00:03:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       Henrik Rydberg <rydberg@euromail.se>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
Message-ID: <20100226080329.GD17062@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-24-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267132893-23624-24-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:21:28PM -0600, Jason Wessel wrote:
> When using a keyboard with kdb, on resuming the system there needs to
> be a hook to allow for the keyboard state to get reset.
> 
> This is mainly because there is no way to force the end user to hold
> down the original keys that were pressed prior to entering kdb.
> 

Instead of adding all the new hook can't you copy the bitmap of
currently pressed keys when you invoke kdb and theni, on exit, use
input_inject_event() to clear bitmasks in the devices?

-- 
Dmitry
