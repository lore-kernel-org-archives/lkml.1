Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYCQPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYCQPrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYCQPrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:47:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:39163 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYCQPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qd2bTJXW3CONK7XgOxgPKM9rdGygw78yCuDI2XIm1Fyr1dSkVyJcGvGiB7naYSwfDADXAfQjMHI3iZ9F0AT+8cvPBRYlhtUjRZbfeUmwKjJylPuHTQSQaUZXYkVzQ3OzG0i2Ofhhn5wpOgAj6ZwsiNRcH7rhZrj2SyHXyclC2no=
Message-ID: <2c0942db0803170847n3e88bdf6r33eabe4c15e7d3f2@mail.gmail.com>
Date: Mon, 17 Mar 2008 08:47:30 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: 2.6.25-rc1/2 regression: first-time login into gnome fails
Cc: "Romano Giannetti" <romanol@upcomillas.es>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080317120641.GA16710@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203332161.26696.11.camel@pern>
	 <2c0942db0802180815r59c2ef1s8d4c2e1e733b79c4@mail.gmail.com>
	 <20080317120641.GA16710@infradead.org>
X-Google-Sender-Auth: e69e85df15d79267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 5:06 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Feb 18, 2008 at 08:15:01AM -0800, Ray Lee wrote:
>  > It may be a race. Please try booting up, then waiting for a minute or
>  > two once you see the gdm login screen, then try logging in.
>  >
>  > If that succeeds then something (dbus perhaps) is hanging on something
>  > that eventually times out.
>
>  Just upgraded my laptop to 2.6.25-rc6 and I see the same.  A little
>  instrumentation shows that there is no socket to connect to aka the
>  server side process (whatever that is) didn't start.

Hmm. Okay, mind if I ask some stupid questions?

I'm assuming you upgraded from 2.6.24, correct? (not .25-rcX).

Are you running either debian or ubuntu? If so, do you have the
dbus-x11 package installed? Alternately, does /usr/bin/dbus-launch
exist? If no, try installing dbus-x11 and try again. I think a
side-effect of installing is to start dbus earlier, and may perhaps
avoid the race (if it is a race that's causing all this, which I still
think it is).

References if you're bored:
  http://bugzilla.gnome.org/show_bug.cgi?id=395488
  http://www.mail-archive.com/desktop-bugs@lists.ubuntu.com/msg139625.html

If the above doesn't help, is there anything interesting in ~/.xsession-errors?
