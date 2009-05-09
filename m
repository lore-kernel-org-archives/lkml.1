Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZEIPKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZEIPKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZEIPK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:10:26 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49543 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZEIPKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aVot6e9UjqJoB52sQYFcW/fS4oN7qF5uUU/utebxPx9bCHZzk9DqoRa5PO3+QL7bks
         pcjqePKRgDuPjUW2HCbDARXqlVrTxijEayCFw38No2F8YXSWd1xDsvzJvX11qDhMAN/U
         s42GwH9jHh9xXDFHJhGcpog5NE6gsbP92evaU=
MIME-Version: 1.0
In-Reply-To: <20090509143742.GA27663@kroah.com>
References: <20090509143742.GA27663@kroah.com>
Date: Sat, 9 May 2009 17:10:24 +0200
Message-ID: <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, May 9, 2009 at 4:37 PM, Greg KH <greg@kroah.com> wrote:
> Here's the latest version of the devtmpfs patch, broken up into 13
> different patches to make it easier to review and merge properly.
>
> This series does the following:
>  - creates a new callback within the driver core to allow drivers and
>    subsystems to provide a name for their subsystem to properly reflect
>    what userspace should use for their device nodes.  This allows for
>    things like the sound/ and input/ subdirectories to be properly told
>    to userspace.  Note these names and subdirectories are the ones that
>    have been used for years, and are standardized across all
>    distributions and synced up with the LANANA naming scheme which is
>    specified by LSB.  We aren't creating anything new here.
>  - fills in the callbacks by the various subsystems that need to define
>    it, including the misc device layer.  This is the majority of the
>    patches in the series.
>  - adds the devtmpfs core code.  Description of what this is, why it is
>    needed, and how it works is within this patch.
>
> All of these patches have been tested for a number of weeks now in
> SuSE's kernel trees and have proved to increase boot time a measurable
> ammount (a few seconds at the very least)

Well, guess you meant the opposite ;-)


> on both traditional systems
> (servers / desktops) as well as on netbooks using a non-SuSE based
> userspace infrastructure.
>
> This feature also allows rescue systems to work properly by allowing
> systems to boot into /bin/bash with full access to all of their device
> nodes.  It is also a big win on embedded systems with no local users yet
> they need to provide dynamic names as their hardware configuration can
> be changed by external forces.
>
> All of the previous objections to this patch series seems to have been
> properly addressed, but as always, comments are welcome, just make them
> substantial please :)
>
> These patches are now in the driver-core git tree of quilt patches.
>
> thanks,
>
> greg k-h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
