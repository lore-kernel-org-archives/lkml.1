Return-Path: <linux-kernel-owner+w=401wt.eu-S1763669AbXJNWFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763669AbXJNWFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXJNWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:05:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:5745 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbXJNWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=X3YBno+TnfyfHBs9yWIGFo+rs4hdCSELbEyXad5jCW4PjZc2X8M0HzRxHZ1la+3QwBDbGrMwWw/33/gysqlSy5Zxk0S0cDq0+lZWgvwNa/zir+R4z6a37MAgVS393AQdJWv/oq2dwhpvLyj6poi64Z6G4PESyU+WfRwAoUmnH3E=
Message-ID: <71b295590710141505x54ca0a8fwebfd75ab4fdf2e71@mail.gmail.com>
Date: Sun, 14 Oct 2007 17:05:12 -0500
From: "Mark Weber" <crash@treysoft.com>
Reply-To: crash@treysoft.com
To: "Bart Samwel" <bart@samwel.tk>
Subject: Re: hdparm standby timeout not working for WD raptors?
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <471284A7.1060800@samwel.tk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
	 <470E7B90.5060203@rtr.ca>
	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
	 <470F7705.3@rtr.ca>
	 <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>
	 <47120D65.3080008@samwel.tk>
	 <71b295590710141330g7a4779e5q2d6b8f50387ee971@mail.gmail.com>
	 <471284A7.1060800@samwel.tk>
X-Google-Sender-Auth: 83e316d502a3866c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Bart Samwel <bart@samwel.tk> wrote:
>
> Just to be sure: you did use -S 60 to get 5 minutes, right?

Yes. And hdparm is kind enough to print:

/dev/sda:
 setting standby to 60 (5 minutes)

Here's a bizarre sequence which I just noticed:
[extraneous blank lines removed for clarity]

>> hdparm -C /dev/sd[abcde]
/dev/sda:  drive state is:  standby
/dev/sdb:  drive state is:  standby
/dev/sdc:  drive state is:  standby
/dev/sdd:  drive state is:  standby
/dev/sde:  drive state is:  standby

>> hdparm -S 60 /dev/sda
/dev/sda: setting standby to 60 (5 minutes)

>> hdparm -C /dev/sd[abcde]
/dev/sda: drive state is:  active/idle
/dev/sdb: drive state is:  active/idle
/dev/sdc: drive state is:  standby
/dev/sdd: drive state is:  standby
/dev/sde: drive state is:  standby

Note that the -S 60 on /dev/sda affected
/dev/sdb too! This is repeatable.

I have these drives as RAID5 (software RAID).
I don't know if that has anything to do with the
failure of -S or not. Don't know if hdparm bypasses
the RAID or not.
