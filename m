Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYDXQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYDXQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYDXQpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:45:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:33248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYDXQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VCjJspqkJ2or4WxYDsrbYfUUF0xFIidhcydv5gDOJ4Qv2rnmAkjby0mIEyJszKnsoOG0fXS7H7BY6rNl0eT6tgzP+PglyT16ARpwJSiILcyt5qPlTN6Z/W94P6d6Ly8b1glScNwdi4g51NYytpKY+aVDaEUOfk8PSsIA+FL/OKk=
Message-ID: <517f3f820804240945l2dc203afx8fa432ac41219236@mail.gmail.com>
Date: Thu, 24 Apr 2008 18:45:43 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: "David Miller" <davem@davemloft.net>, jakub@redhat.com, drepper@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <20080424163835.55520b5b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080424160352.30f2dd5b@the-village.bc.nu>
	 <20080424154441.GG2255@devserv.devel.redhat.com>
	 <20080424162444.1c5b9ba2@the-village.bc.nu>
	 <20080424.090008.232544945.davem@davemloft.net>
	 <20080424163835.55520b5b@the-village.bc.nu>
X-Google-Sender-Auth: 6b3b6cba06f3af79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 24 Apr 2008 09:00:08 -0700 (PDT)
>
> David Miller <davem@davemloft.net> wrote:
>
>
> > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>  > Date: Thu, 24 Apr 2008 16:24:44 +0100
>  >
>  > > BTW in 4.4BSD and derivatives if I remember rightly F_CLOEXEC *is*
>  > > inherited across accept() so I doubt any user space software will be too
>  > > upset by such a shift.
>  >
>  > It actually doesn't.
>  >
>  > Just like in Linux, no file descriptor flags are inherited.
>
>
> NDELAY certainly appears to be looking at Stevens.

A while back I did some testing of this point.  These were the results I noted:

FreeBSD 4.8
O_NONBLOCK and O_ASYNC are inherited
FD_CLOEXEC is not inherited

Solaris 8
O_NONBLOCK and O_ASYNC are inherited
FD_CLOEXEC is not inherited

Tru64 5.1 (sep 03, testdrive)
No F_SETFL flags are inherited
FD_CLOEXEC is not inherited

HP-UX 11
No F_SETFL flags are inherited
FD_CLOEXEC is not inherited
