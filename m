Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYISTYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYISTYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYISTY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:24:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbYISTY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:24:28 -0400
Message-ID: <48D3FBF7.4000106@redhat.com>
Date: Fri, 19 Sep 2008 15:22:31 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Singaravelan Nallasellan <singaravelann@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: New IOCTLs
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>	 <48D164B9.7020507@redhat.com> <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
In-Reply-To: <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Singaravelan Nallasellan wrote:
> Thank you for your response.
> 
> The driver needs to assign an id for each open and create a sysfs
> entry based on that id and expose some properties.
> 
> For example, if the driver assigns an id 2, the sysfs entry will be as below:
> /sys/class/xxx/<drivername>/2/version
> 
> When the driver close is invoked, it will have to remove the entry.
> 
> The issue here is that the application needs:
> 1. To know the id it should use to access properties after the open.
> 2. To have exclusive access to the sysfs entries. No other application
> should and open the entry and use it. There is a chance the the other
> application could open the entries before this application opens it.
> 
> The driver allows multiple opens and assigns any random id.
> 
> I appreciate your suggestion on alternate ways to implement the functionality.

If you really need for each file descriptor that opens your device to have a 
unique context and set of properties that may be different from the rest, then 
an IOCTL might be legitimate here.  If the device behaves the same way 
independent of context, then it's really just a locking issue, sysfs is the way 
to go.

-- Chris

> On Thu, Sep 18, 2008 at 1:42 AM, Chris Snook <csnook@redhat.com> wrote:
>> Singaravelan Nallasellan wrote:
>>> I need to send device control messages to the driver. I am planning to
>>> use the IOCTLs. But I came to know that Linux community does not
>>> accept any new IOCTLs anymore.
>>> Can somebody provide the reason behind the decision? Are there any
>>> better approach to implement the device control interface other than
>>> sysfs interface. I have some issues in using the sysfs interface.
>>> Thanks in advance.
>> IOCTLs are discouraged, but not strictly forbidden.  Is there something
>> about sysfs that would make it an unsuitable interface, or are you just
>> having trouble finding good documentation on using it?
>>
>> -- Chris
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

