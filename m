Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZAHHRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZAHHRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZAHHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:16:59 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:57861 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZAHHQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=ZzhdzCYkg6nbckFXtu3B5QJS+S2TcaBe75o51p51eoKLXFm92uvKFr6Ol4wXPSmMxu
         krM0o+iiLtRJY3YW9ZtsSFo4G8iG9A5UvZ3v9ctK7z/zlUaWeXqxFPibCejKYwefTfm7
         AY+IhvIIWlUWCBhrxAWG2Z8X0cNeVWXRhRhhw=
Date: Thu, 8 Jan 2009 07:16:51 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Ben Mansell <ben@zeus.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090108071651.GA4496@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106181559.GA29426@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-01-2009 19:15, Willy Tarreau wrote:
...
> Ah, so you might also have discovered a few annoyances with the API, eg
> the fact that splice() returns after the first read in non-blocking mode,
> as well as the fact that it never returns zero on close, but -EAGAIN,
> which requires an additional recv(MSG_PEEK) to distinguish between a
> close and a lack of data. But I leave that for a later discussion, let's
> address the corruption issue first.

FYI, this should be just fixed:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4f7d54f59bc470f0aaa932f747a95232d7ebf8b1

Regards,
Jarek P.
