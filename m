Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbZAFAO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbZAFAO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZAFAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:14:50 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:26950 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750719AbZAFAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:14:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fIX9zdWMrimMkUnY/vkmTTCzSvhjtFyuvq4dC7oq+Ze5+YNmOvJ2Z/iwVyN/7dhQuqmameA4ewSofhQyRen67Wrq4ml83/qwAwNtIFFy8z1mqWZGaloSuc/T9FLFI8elVgsdjuJw9Sf8dhBsFGz2B6mp0Z+7ofbz8tKM8VEIU/k=  ;
X-YMail-OSG: M00f5V4VM1kmN_H3NXkkDpk6OsryU44lIU0JvBso0MfatObCX_Y_r0oKsc58bXX0dM5Pjk5OR7U6VLAkDJok3q_ZZK1YYyTLmSx5NytDgyS6PbB2.mCO.H3J23zmzhY0jnQHwXKkWOu3eN1aug0oPdfs
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
Date: Mon, 5 Jan 2009 15:45:04 -0800
User-Agent: KMail/1.9.10
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
References: <200812011335.43551.david-b@pacbell.net> <200812012150.36342.david-b@pacbell.net> <20081202133228.GD7940@sirena.org.uk>
In-Reply-To: <20081202133228.GD7940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901051545.04912.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008, Mark Brown wrote:
> > Also make sure the consumer device is provided.  It's nonsensical
> > to omit these, and not a documented part of the interface.  Since
> > no code in mainline does such stuff, this is just anti-oops medicine.
> 
> ...we do still need to cater for cpufreq and other struct deviceless
> consumers.  If you can guarantee that no such consumers will ever exist
> then great but we're not there yet.

Just for the record:  my feeling is that since no such
drivers currently use the regulator framework, it's wrong
to design-in breakage to support them.

When someone writes a cpufreq driver that uses the
regulator framework, they can arrange to provide the
relevant "struct device *" to make that work neatly.

Meanwhile, I still think the regulator framework should
be using driver model messages.  Since the only reason
not to use them is to support those non-existent drivers.

- Dave

p.s. Glad to see at least part of this patch get merged,
   even if related diagnostics are lacking.


