Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbZJGQC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbZJGQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZJGQC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:02:28 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:64494 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZJGQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:02:27 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 12:02:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JeBFqHjKjNddz3rXcOr9a+80liywgyRr3sR7GOVZNVLwejhVDpwoaCfMHr65RCyMHv
         HLfuNRF1CYgkBwB5s6XQjFA7bt+AV+qhqArImsl0EZkUqWA/Oir3qIpgFWbYilBH8HNU
         ZQIBXfODeQXeq8Lks4pALGSOthBbTjeBJzSH0=
Date: Wed, 7 Oct 2009 17:56:02 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Cox <alan@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/5] opticon: Fix resume logic
Message-ID: <20091007155602.GB12396@localhost>
References: <20091006145413.9431.47083.stgit@localhost.localdomain>
 <20091006150651.9431.16939.stgit@localhost.localdomain>
 <200910062312.17832.oliver@neukum.org>
 <20091006232331.5684bbee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006232331.5684bbee@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 11:23:31PM +0100, Alan Cox wrote:
> On Tue, 6 Oct 2009 23:12:17 +0200
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Dienstag, 6. Oktober 2009 17:06:57 schrieb Alan Cox:
> > > Opticon now takes the right mutex to check the port status but the status
> > > check is done wrongly for the modern serial code, so fix it.
> > 
> > As Alan Stern noticed, it seems like we have an ab-ba deadlock here
> > between open and resume regarding pm_mutex and port->mutex.
> 
> Oh well I guess someone with hardware will have to fix that.
> 
> Do we actually need a separate pm_mutex anyway ?

The pm_mutex is actually not aquired during open (and Alan Stern just
confirmed that), so there is no dead-lock with port->mutex.

/Johan

