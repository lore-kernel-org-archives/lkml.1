Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYAXLw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYAXLw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYAXLwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:52:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:51744 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYAXLwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cIK0RbV0/diadRlqqIxbdvwJZzA/DbOi+3T/1Na7GqvTx77pOH+KhTAPyGLfEagjf2guGMiF+VpfePrkNwF4xWd6eK7SMtMlimDSdy8lDnMIqYFarA4+hIFc8PHo82iNiNRlhslANnpTgDhJ6ilBrJTy75K/wIuneB/lG/qLCiE=
Message-ID: <84144f020801240352r688fbbccu52ce9aa8ea3f199@mail.gmail.com>
Date: Thu, 24 Jan 2008 13:52:45 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801241249.06577.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
	 <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
	 <200801241249.06577.oliver@neukum.org>
X-Google-Sender-Auth: 5de89f4c58c608da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Jan 24, 2008 1:49 PM, Oliver Neukum <oliver@neukum.org> wrote:
> A quick glance through the files at sourceforge indicates that this
> device use a file transfer protocol. Mapping this to a simple device
> is hard. A fs is quite natural a representation of that.

Sure but the filesystems in fs/ are general purpose and they can be
mounted on top of any block device (except for the in-memory ones like
sysfs). Furthermore, the problem with iriverfs is that it assumes that
there can be only one device plugged to the host. What we want is
something like

  $ mount -t iriverfs /dev/iriver0 /mnt/media

Which can be accomplished with an USB driver in driver/usb/ that
registers the special iriverfs.

                        Pekka
