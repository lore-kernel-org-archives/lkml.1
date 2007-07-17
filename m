Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbXGQG2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbXGQG2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXGQG2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:28:37 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:25150 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbXGQG2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=YNq4wHYM3BZxI7XG7A38AyprNCGjD+Eo68x9O4uSWNsv43Wl1f7kgfdLRWR6eoDPK8VWn5pPLdOPz/bqgea0zmeSwRrpS0WyoIK62P/TRI01QqTOM1g4fvmpJBANylv+r2Qv5QK3Ep3S8vdKpnm7XW5amXeXwTJ6oiBad2gG5yI=
Date: Tue, 17 Jul 2007 02:28:03 -0400
To: Oliver Neukum <oliver@neukum.org>
Cc: Joseph Fannin <jfannin@gmail.com>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       david@lang.hm, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070717062803.GA9069@nineveh.local>
Mail-Followup-To: Oliver Neukum <oliver@neukum.org>,
	Joseph Fannin <jfannin@gmail.com>,
	Jeremy Maitin-Shepard <jbms@cmu.edu>, david@lang.hm,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200707121453.49616.rjw@sisk.pl> <87odig1idx.fsf@jbms.ath.cx> <20070717001239.GB20082@nineveh.local> <200707170744.08191.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707170744.08191.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 07:44:07AM +0200, Oliver Neukum wrote:
>
> If yoi want to go the kexec route to hibernation, the dumping kernel
> would need to mount the filesystem to write to a file. Therefore the
> suspending kernel would need to sync to disk and lock that file.

If the file is preallocated, that's not a problem, as there's no need
to touch filesystem metadata.  There'd need to be some channel to pass
the disk blocks that are for writing the image, but that's not going
to be nearly as complicated as passing the current swap data
structures from the previous kernel.

There's no reason to have that file open in the original kernel --
it should be root-owned (it's full of privledged data) and probably
mode 000.

root is free to "dd if=/dev/random of=/dev/mem".  Root owned
daemons which do bad things are bugs.

Again, supporting swap files (*which is not optional*) requires the
very same support.

--
Joseph Fannin
jfannin@gmail.com

