Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYAEVVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYAEVVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYAEVU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:20:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:40838 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbYAEVU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=b9CSaluJuibmO4Ojpbg2TSxaSQW+sbhOxLe4HtWI/qb1BgWGW15gDGZU+r0KTmrB46ToE5kGSJKUGoe+w35jvUmY02l1VTSAk1d2L40bqaJH2I6hkHW3p8Cyxlz7K/d5AtJms2fyJxKyv5lwKuoIXyoitFO+FQlfDABy5HVbCJg=
Date: Sun, 6 Jan 2008 00:20:50 +0300
To: Alexander Shaduri <ashaduri@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080105212050.GA2434@martell.zuzino.mipt.ru>
References: <20080104213812.20268840@linux.localdomain> <20080105091012.GG27894@ZenIV.linux.org.uk> <20080105173601.75370546@linux.localdomain> <18303.38257.850625.70108@harpo.it.uu.se> <20080105184656.52b1f7d3@linux.localdomain> <20080105201622.GL27894@ZenIV.linux.org.uk> <20080106003034.15a75d4c@linux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106003034.15a75d4c@linux.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 12:30:34AM +0400, Alexander Shaduri wrote:
> > Get a serial console?  Take another box, plug e.g. pl2303-based
> > usb-to-serial (several bucks these days) into it, stick null-modem
> > convertor (ditto) on its serial end and attach to ttyS0 on the
> > victim.  console=ttyS0 on victim, something like minicom on watcher
> > and tell it to capture log into file...
> 
> I will try that (as soon as I acquire the necessary parts).

netconsole should be more quick:
* one more box with ethernet card
* CONFIG_NETCONSOLE=y
* CONFIG_ {your NIC driver} =y
* on crashing box add the following line to the kernel boot options

	netconsole=@src-ip/eth0,9353@dst-ip/dst-MAC

where	scr-ip -- IP of crashing box
	eth0 -- interface on crashing box
	9353 -- destination port (for netcat to listen on target box)
	dst-ip -- IP of a box which collect logs
	dst-MAC -- MAC of the interface on destination box

* on destination box run netcat

	nc -u -l -p 9353 &>1.log

[* add ignore_loglevel on crashing box if paranoid]

Now reboot crashing box and reproduce the bug, chances are high that it
will send oops over network.
