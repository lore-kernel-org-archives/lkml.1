Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYHANje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYHANje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYHANj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:39:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:23713 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYHANj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=J9Tuxf+0Ey9OMRijfXgPPYKvMFeRASmJ9sdlxut80zN5U79ju7sl4tEzQVQxd8O9OF
         0nIrEFb0u4YMhJixMXnKCRRSDFCw9UwtRbh5IxVFVe1dKJESAHSEHBT1AUG3WyqMdE3A
         QnjS8fHEi7ikYnGMSkv3OZMlApPU+K/Qjpe1E=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc1: strange fstab issue (Re: 2.6.27-rc1 + selinux new options = no httpd)
Date: Fri, 1 Aug 2008 09:39:04 -0400
User-Agent: KMail/1.9.9
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
References: <200807302254.26036.gene.heskett@gmail.com> <Xine.LNX.4.64.0808010559290.30244@us.intercode.com.au> <200808010017.28125.rjw@sisk.pl>
In-Reply-To: <200808010017.28125.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200808010939.04186.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, Rafael J. Wysocki wrote:
Update by Gene below.
>On Thursday, 31 of July 2008, James Morris wrote:
>> On Thu, 31 Jul 2008, Gene Heskett wrote:
>> > >Which new options?
>> >
>> > Make xconfig-->security options:
>> >
>> > XFRM Networking security hooks
>> >
>> >  and several others just below it.  Unforch, I can't copy/paste the
>> > screen.
>>
>> I can't really imagine what that is (although if you enable the secmark
>> controls under the main SELinux menu, which are disabled by default,
>> there could be problems).
>
>On a possibly related note, I've been observing a strange issue on one of
>my test boxes with OpenSUSE 10.3 recently.   Namely, the fsck complains
>that there's no passno value in the fstab, although it obviously is present.
>
>Strangely enough, if the kernel is compiled with CONFIG_SECURITY_SELINUX
> unset, the fsck doesn't complain about the missing passno field any more.
>
>Thanks,
>Rafael

I just did a 2.6.27-rc1 rebuild on a pure, all defaults 'make oldconfig' from
my 2.6.26 final .config moved to that src tree.

httpd is still being denied access to its log files and dies during the bootup.

This is a showstopper for me.

>From the log:
Aug  1 09:12:13 coyote setroubleshoot: SELinux prevented httpd reading and writing access to http files. For complete 
SELinux messages. run sealert -l ecd4e1d6-59fa-47ff-830d-3fb7d9114805

>From the output of that report:
The following command will allow this access:

setsebool -P httpd_unified=1
(Gene: but it is not effective)
Additional Information:

Source Context                system_u:system_r:httpd_t:s0
Target Context                system_u:object_r:httpd_log_t:s0
Target Objects                ./error_log [ file ]
Source                        httpd
Source Path                   /usr/sbin/httpd
Port                          <Unknown>
Host                          coyote.coyote.den
Source RPM Packages           httpd-2.2.8-1.fc8
Target RPM Packages
Policy RPM                    selinux-policy-3.0.8-109.fc8
Selinux Enabled               True
Policy Type                   targeted
MLS Enabled                   True
Enforcing Mode                Enforcing
Plugin Name                   httpd_unified
Host Name                     coyote.coyote.den
Platform                      Linux coyote.coyote.den 2.6.27-rc1 #2 PREEMPT Wed
                              Jul 30 19:05:14 EDT 2008 i686 athlon
Alert Count                   11
First Seen                    Tue Jul 29 15:51:41 2008

There is more but you've seen it previously I believe.

Thanks for any help/solution.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Advertising may be described as the science of arresting the human
intelligence long enough to get money from it.
