Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXBFOci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXBFOci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXBFOci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:32:38 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56717 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbXBFOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:32:38 -0500
X-Sasl-enc: pZdZ99levmz3YRwu+aGSrGQSA4RHvJcR4Z1hxWYkms7I 1170772356
Date: Tue, 6 Feb 2007 12:32:31 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070206143231.GD18392@khazad-dum.debian.net>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org> <20070203003536.GA619@khazad-dum.debian.net> <1170710913.6105.39.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170710913.6105.39.camel@nigel.suspend2.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007, Nigel Cunningham wrote:
> Why do you think remounting filesystems is necessary? Are you getting
> problems with some particular filesystem?

No.  But anything in a removable device neets to be either remounted
read-only or unmounted if that is at all possible, because the user could
unplug it.  It is of course, sync'd anyway, so if the remount/umount fails,
no corruption should happen...  but the fs will be dirty, etc.

It can get very ugly when you factor in docks and removable bays. It's not
just USB/firewire mass-storage devices and memory cards.  And there is the
patological cases where the user suspends with the device in one port, and
resumes with the device in another port.

I feel userspace *can* do all that needs to be done, but we are (currently)
very bad at it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
