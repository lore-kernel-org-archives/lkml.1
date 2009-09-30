Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZI3Boj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZI3Boj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZI3Boj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:44:39 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:63922 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZI3Boi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MHt/yfAv3w8eJyja7sjGZisTPjSYCgwsK6LtrGwbmdCRAUzzDvePk8VpBwGMK0RPg1
         FXqVcGIdxtmDNiun38vJi0h/RPoGV9UreCStTGWlyokCtfzihNrchn6uC+TryHQynEXC
         EdQWPCj++eAmPVYnIFEH3TbcjNZvrer3+7rIs=
MIME-Version: 1.0
In-Reply-To: <20090929182746.245afa74.akpm@linux-foundation.org>
References: <1253161357-22453-1-git-send-email-vapier@gentoo.org> 
	<20090929153902.ab74aa01.akpm@linux-foundation.org> <8bd0f97a0909291814l2de1f989lcf640633cf25b9c8@mail.gmail.com> 
	<20090929182746.245afa74.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 29 Sep 2009 21:44:22 -0400
Message-ID: <8bd0f97a0909291844j17f485edib7417015d90b4784@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] ad525x_dpot: new driver for AD525x 
	digital potentiometers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, chrisv@cyberswitching.com,
       linux-kernel@vger.kernel.org, michael.hennerich@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 21:27, Andrew Morton wrote:
> On Tue, 29 Sep 2009 21:14:37 -0400 Mike Frysinger wrote:
>> > + __ __ __ if (reg & AD525X_REG_TOL)
>> > + __ __ __ __ __ __ __ return sprintf(buf, "0x%04x\n", value & 0xFFFF);
>> > + __ __ __ else
>> > + __ __ __ __ __ __ __ return sprintf(buf, "%u\n", value & data->rdac_mask);
>> >
>> > which makes me suspect that the proposed userspace interface is quite
>> > poor.
>>
>> not really.
>
> Think so.  We have a sysfs file which under some circumstances will
> return a decimal number and which under others will return a hex
> number.  So userspace is supposed to look for the leading 0x to work
> out how to interpret that number?
>
> Or something.  Whatever.  Perhaps it all makes sense when one has seen
> the overall description.

no, you're looking at one common function which is called by different
sysfs files.  no point in copying & pasting the same code over and
over.  all of the rdac files display as a hex file while all the
non-rdac files display as a decimal.
-mike
