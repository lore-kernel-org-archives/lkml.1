Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZD1DJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZD1DJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZD1DIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:08:53 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:26209 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752676AbZD1DIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:08:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q3h+7FFSCvd7u95nbPXC4oK8VqNDBCsmVdajnnQFuC+C4fnSArMxjNsu23V/auP3JYU2KE+ZmtUMh/01BFSGb8rGWfj5m4KdVWIiZRdgNIL5lQRxvhdfrjaWs9URuxfm+K62lT5DPUEadv48iPbieT3K4AT+Lq09CwrDZjFWfOM=  ;
X-YMail-OSG: YNEkNHcVM1no.r0YVcagxbKYt_0P0p0qC6x4UATlSBI.iHyST4VlnLYHaTzEn6jgUGjaG1ASdC9WCaXITqhm6kwjbOwr9e8xDOATTWYzBpyBSvCYwtncM3Hk4C3oKRhVjVqLHIk71QonVdj2r2GAo5GouKllv2wnNLLdjHLG1b_VTUwEr2HdftRhQ7FdXDcsx1DnMgJN.1cKFJdaeEopeQlsRb2iMcDzSh0rRusxqHcGVxmvClj0vCbS_6YhBJS0jjOBPWKc6lyKoBn2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH] regulator core: fix double-free in regulator_register() error path
Date: Mon, 27 Apr 2009 20:08:50 -0700
User-Agent: KMail/1.9.10
Cc: linux-omap@vger.kernel.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com> <alpine.DEB.2.00.0904252250230.4291@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.0904252250230.4291@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904272008.50268.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 April 2009, Paul Walmsley wrote:
> 
> > device_unregister() calls regulator_dev_release() which frees rdev.  The 
> > subsequent kfree corrupts memory and causes some OMAP3 systems to oops on 
> > boot in regulator_get().
> 
> For the 3430SDP users out there, this patch also fixes the boot hang after 
> "regulator_init_complete: incomplete constraints, leaving VAUX3 on"
> on that device.

For the record, that "incomplete constraints" message is bogus.
On that board, VAUX3 has a complete set of constraints:  it may
only emit 2.8V.

What it lacks is something entirely different:  driver support
for the LCD which uses the regulator framework, instead of just
bypassing it and talking directly to the PMIC.  By the time it
gets there, the LCD has probably been turned on.

Mark and/or Liam ... you might want to fix that diagnostic, to
avoid leading more developers astray!

