Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYIREYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYIREYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYIREXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:23:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:62730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYIREXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TFfwrparjCwFGKZ+RKAyuD5U4p6uyYQ62Ixo36L5kQrKG1WRVo4tpcemb3RPgG9YJL
         vuSI5XY7qqf0n5ILF5lCcWpyX/d2zKveke38mk+YPlO4C+6dphx8xK647fhMVSVo3y4/
         Yy2hGqZU95WobYHWD4qCnR3Wu78MNMqJF8VYo=
Message-ID: <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
Date: Thu, 18 Sep 2008 09:53:51 +0530
From: "Singaravelan Nallasellan" <singaravelann@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: New IOCTLs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48D164B9.7020507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
	 <48D164B9.7020507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your response.

The driver needs to assign an id for each open and create a sysfs
entry based on that id and expose some properties.

For example, if the driver assigns an id 2, the sysfs entry will be as below:
/sys/class/xxx/<drivername>/2/version

When the driver close is invoked, it will have to remove the entry.

The issue here is that the application needs:
1. To know the id it should use to access properties after the open.
2. To have exclusive access to the sysfs entries. No other application
should and open the entry and use it. There is a chance the the other
application could open the entries before this application opens it.

The driver allows multiple opens and assigns any random id.

I appreciate your suggestion on alternate ways to implement the functionality.


On Thu, Sep 18, 2008 at 1:42 AM, Chris Snook <csnook@redhat.com> wrote:
> Singaravelan Nallasellan wrote:
>>
>> I need to send device control messages to the driver. I am planning to
>> use the IOCTLs. But I came to know that Linux community does not
>> accept any new IOCTLs anymore.
>> Can somebody provide the reason behind the decision? Are there any
>> better approach to implement the device control interface other than
>> sysfs interface. I have some issues in using the sysfs interface.
>> Thanks in advance.
>
> IOCTLs are discouraged, but not strictly forbidden.  Is there something
> about sysfs that would make it an unsuitable interface, or are you just
> having trouble finding good documentation on using it?
>
> -- Chris
>
