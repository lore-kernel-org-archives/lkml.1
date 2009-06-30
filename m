Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZF3RNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZF3RNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZF3RN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:13:26 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50271 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZF3RN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sWxHevl7nyxe5bSwWFJoVjdE2iPdFipp+wTp5AClec300mbtUM4xcJeK7W6Thlxw9M
         lX/TOX/ZOqfrErrPxXQ+qupIEMfdeFlB5n3KuHb7254EGSmSxtJzyA7MBqS4lFvY8A2X
         gpqEKFml/BpilCreP8SzQXMSqJBA+lsjV1mlk=
MIME-Version: 1.0
In-Reply-To: <22424.1246368155@turing-police.cc.vt.edu>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com> 
	<22424.1246368155@turing-police.cc.vt.edu>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 30 Jun 2009 13:13:08 -0400
Message-ID: <3e8340490906301013k3182093w65d68a0d0c2e19e8@mail.gmail.com>
Subject: Re: fanotify: the fscking all notification system
To: Valdis.Kletnieks@vt.edu
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@dmesg.printk.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 9:22 AM, <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 29 Jun 2009 16:08:45 EDT, Eric Paris said:
>
>> fanotify provides two things:
>> 1) a new notification system, sorta like inotify, only instead of an
>> arbitrary 'watch descriptor' which userspace has to know how to map back
>> to an object on the filesystem, fanotify provides an open read-only fd
>> back to the original object.  It should be noted that the set of
>> fanotify events is much smaller than the set of inotify events.
>>
>> 2) an access system in which processes may be blocked until the fanotify
>> userspace listener has decided if the operation should be allowed.
>
> I don't care much about virus scanners - but some of us with petabytes of
> disk space to manage could use tis for HSM applications.  The HSM daemon
> could fanotify on the file, notice that the file accessed referred to a
> special "I've been archived" stub/token, and put the file back before
> giving the go-ahead to the process.
>
> The only sticky question - does this happen early enough that the accessing
> process, when un-blocked, will continue through open() and get the *new*
> version of the newly restored file?
>

In that particular case, why not just make it a sparse file (so the
size fields in stat are correct), and put back the original data in
the very same inode?
