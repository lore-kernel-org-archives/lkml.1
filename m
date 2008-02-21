Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYBUTeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYBUTeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYBUTdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:33:53 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:38207 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751603AbYBUTdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:33:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Lf0ICu4Ig5LahVinyP1eY6jOzX75FTWliNSA4D1J8KKpE8wp4SoZaMEqSjjr961iKlquHmsjBeF0WihnfMwQSaQUbKiEuS8pZ2TTyNFLkMo5ZroTlaS719kPxbZ/1LMsl8JBbYMl/5UpYBYZ/C+CLd/KCmU2Rg42GO502lh07+Q=  ;
X-YMail-OSG: TjiOtoIVM1mukEhW4yALl3u_t2rkFimRalIfKG0A86e9kaFih6dFl5J4GgexRR2qAZmdYlVr8w--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Feb 2008 11:33:50 -0800
From: David Brownell <david-b@pacbell.net>
To: pavel@ucw.cz, jgarzik@pobox.com
Subject: Re: [linux-pm] power_state: get rid of write-only variable in SATA
Cc: linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080221125652.GA23548@elf.ucw.cz>
 <47BDA22F.5060300@pobox.com>
In-Reply-To: <47BDA22F.5060300@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080221193350.DA772235007@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> libata uses it under the assumption that "other parts" of the system are 
> aware of this variable.
>
> May I assume that the API has changed such that this is no longer necessary?

Yes.  The original motivation for dev->power.power_state was to let
the writes to /sys/devices/.../power/state support a PCI-specific
policy for device power state transition.  And the motivation for
any driver (or framework) to modify that was that the PM core didn't
update it in all the relevant code paths (it wan't clear how to do
that either), which mean those sysfs files could make trouble.

That file is gone; everything supporting its usage can now go away.
(And the PCI-specific policy -- "only transitions to/from D0 are
allowed" -- can be managed by PCI drivers, and ignored by others
on more flexible hardware.)

The minor problem removing it is that there's some code which has
used fields in power_state for some driver state.  But if all that
usage is write-only in the drivers (is that true now for SATA?),
then it's safe to remove the /sys/devices/.../power/state support
from framework code and elsewhere.

- Dave


