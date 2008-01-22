Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYAVVZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYAVVZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYAVVZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:25:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51284 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYAVVZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:25:27 -0500
Date: Tue, 22 Jan 2008 21:25:01 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
Message-ID: <20080122212501.GA17434@flint.arm.linux.org.uk>
Mail-Followup-To: Greg KH <greg@kroah.com>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
	Adrian Bunk <bunk@kernel.org>
References: <20080120200527.GA23852@uranus.ravnborg.org> <1200859743-24037-1-git-send-email-sam@ravnborg.org> <1200859743-24037-2-git-send-email-sam@ravnborg.org> <1200859743-24037-3-git-send-email-sam@ravnborg.org> <1200859743-24037-4-git-send-email-sam@ravnborg.org> <1200859743-24037-5-git-send-email-sam@ravnborg.org> <1200859743-24037-6-git-send-email-sam@ravnborg.org> <1200859743-24037-7-git-send-email-sam@ravnborg.org> <1200859743-24037-8-git-send-email-sam@ravnborg.org> <20080122211715.GA26279@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122211715.GA26279@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 01:17:15PM -0800, Greg KH wrote:
> I like this a lot.  It makes things much more understandable from a
> driver developer's point of view, and would allow us to mark some things
> as freeable when we do not run with a CPU hotplug system :)

You mean at run time - I'm not sure if there's any advantage to that.

In order to free the hotplug cpu data and text, you'd have to make
those sections page aligned - and then you have the question of
how much space you are wasting in doing so.  That will be variable
over time as the code changes.

Also, if you were to merge the hotplug cpu text and data to reduce
the wastage, would that cause any architectures any issues?  (Thinking
about execute-only being set on the kernel's text section only, etc.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
