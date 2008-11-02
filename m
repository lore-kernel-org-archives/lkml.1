Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYKBDqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYKBDqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 23:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYKBDq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 23:46:27 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51195 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYKBDq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 23:46:26 -0400
X-Sasl-enc: T7Y9IS7KY1tMI27e9/drpFAvJ7CGA8fOxQmk16Lx/s+X 1225597584
Date: Sun, 2 Nov 2008 01:46:20 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4 and 5
Message-ID: <20081102034620.GA29606@khazad-dum.debian.net>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031171126.GA17313@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Matthew Garrett wrote:
> > Actually, normal boot doesn't preserve the setting either.  Your commit
> > changes the behaviour from the rfkill state being persistent across
> > reboot / power off (as a bios setting), to being always enabled on
> > boot.  It seems like a bad idea to me.
> 
> This is the behaviour of the rfkill core.

When you don't use rfkill_set_default().  Which, if you are a platform
driver, and your platform can store state across power off, you should use.

Yeah, it is a new thing, sort of. But it is in mainline already, so feel
free to use it.  The right way to do it is to call it BEFORE doing any
rfkill_register or rfkill_allocate.  Only the first caller for a given
rfkill type, wins.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
