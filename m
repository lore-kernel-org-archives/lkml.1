Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYHFEtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYHFEtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYHFEkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:40:33 -0400
Received: from web34502.mail.mud.yahoo.com ([66.163.178.168]:37430 "HELO
	web34502.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753243AbYHFEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:40:32 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 00:40:32 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=NCAN3LvYp4nWQiuipjCc47UDDgbzsY+b+SZQRHsDG52mc7JMybvAJ6+wXQTsREnVfVxOQx7+4MyGVVKsVHzToTpjZjlqIvDdS3573ccI5fJKEddWT1q84+NwJ7Z6zZhqEwO0YvB8m0Oobt5biHLi+90Xdvv4vCvGnjsJ8x+Pufo=;
X-Mailer: YahooMailWebService/0.7.218
Date: Tue, 5 Aug 2008 21:33:52 -0700 (PDT)
From: gus3 <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
To: Karel Zak <kzak@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Jasper Bryant-Greene <jasper@amiton.co.nz>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20080805233956.GI21635@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <510965.21937.qm@web34502.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 8/5/08, Dave Chinner <david@fromorbit.com> wrote:

> So what is the correct behaviour? Should the filesystem
> *silently
> ignore* unchangable options in the remount command, or
> should it
> fail the remount and warn the user that certain options are
> not
> allowed in remount?

How about a middle ground: ignore, but not silently? Report an error, or send it to the syslog, or both, but ultimately ignore unchangeable options, change what can be changed, and give the user/admin as much as possible.

This can be particularly pertinent for XFS root. If it's mounted RO at first, it may (will?) need to become RW at some later point. Failing the remount could result in a system that requires a rescue CD (or lots of headaches for remote administration).
