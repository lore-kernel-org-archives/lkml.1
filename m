Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbXIYDh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbXIYDh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 23:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXIYDht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 23:37:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:6989 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXIYDhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 23:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tYqqFqOdaF5BWKRue9X8q7OwDhJqdSRSOSSJb5EZH1Pe6ic8Qx95q9QrFsKiGS6FmVcgmWG0L4FXYYDvkxJ9wRHmWbTf1W63rc5x3A0zLRAVXe1dpXX6gFg8QtEmTi08arUd1uAgpLbb3+ZpKCXZ9mitH81/MlyjBWzQKkLPuj8=
Message-ID: <46F8822D.2010003@gmail.com>
Date: Tue, 25 Sep 2007 12:36:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>	 <1190677332.27805.229.camel@localhost.localdomain>	 <46F86727.4050004@gmail.com>	 <1190686320.27805.258.camel@localhost.localdomain>	 <46F874DB.5070205@gmail.com> <1190690493.27805.263.camel@localhost.localdomain>
In-Reply-To: <1190690493.27805.263.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> As stated you cannot protect arbitrary code this way, as you are trying
> to do.  I do not think you've broken any of the current code, but I
> cannot tell.  You're certainly going to surprise unsuspecting future
> authors.

Can you elaborate a bit?  Why can't it protect the code?

> Can you really not figure out the module owner of the sysfs entry to inc
> its use count during this procedure?  (__module_get()).

I can but I don't think it's worth the effort.  It will involve passing
@owner parameter down through kobject to sysfs but the path is pretty
obscure and thus difficult to test.  I think it's too much work for the
users of the API and it will be easy to pass the wrong @owner and go
unnoticed.

Thanks.

-- 
tejun
