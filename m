Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYBPXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYBPXSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 18:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYBPXS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 18:18:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:59935 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYBPXS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 18:18:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x8vwvUF9A965rh0ziwIyZqC6AQ1p27x0HI0YZ0KjPFSB6z/RWQOmgHpp2+5nPbXl9lgwiZnEGJZ4L8Vm6kEXZj4jKIH0KKHwg7Y3f+V+ZarW+JXFXvC1va2zfGssBTIYqwpIcC8ws7WAjPCCUlLej9I+krhV5xwFzaCSTNoNwPM=
Message-ID: <3d8471ca0802161518h3fe87f5encc83e7cc976ccef9@mail.gmail.com>
Date: Sun, 17 Feb 2008 00:18:08 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: 2.6.25-rc2: wpa_supplicant BUGs kernel in rwlock recursion
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Laszlo Attila Toth" <panther@balabit.hu>,
       "David Miller" <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <5a4c581d0802160914m7778cf3av5c01c54374f26f5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0802160914m7778cf3av5c01c54374f26f5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 6:14 PM, Alessandro Suardi <alessandro.suardi@gmail.com> wrote:
> Feb 16 16:51:49 sandman kernel: BUG: rwlock recursion on CPU#0,

Same thing here, bisected it to:

commit 45b503548210fe6f23e92b856421c2a3f05fd034
Author: Laszlo Attila Toth <panther <at> balabit.hu>
Date:   Tue Feb 12 22:42:09 2008 -0800

    [RTNETLINK]: Send a single notification on device state changes.

The revert applies cleanly and fixes the problem.
Rafael has more details in http://lkml.org/lkml/2008/2/15/542.

-- 
Guillaume
