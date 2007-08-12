Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbXHLJtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbXHLJtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXHLJok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:44:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:52970 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760935AbXHLJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aS12i5OPm7jr9EijT2JoBeq/nKxa3CzEb5NRfuOxzbGchRFwfJnXJL75wSQLEwaxeb0MYpHNbPoktQ4epMoZ9sfY5opGDsQDlDBeXnFbc4jdKPevg985ycGEVUdzY2q/jI1o8Sd6GLc49QMsBfCUbe4YRYu5XCKhv2m329nS3AI=
Message-ID: <a56dfcf00708120244x3ae8f4w9183354cf5f33f93@mail.gmail.com>
Date: Sun, 12 Aug 2007 05:44:36 -0400
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: reset during bootup - solved
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/07, Dan Merillat <dan.merillat@gmail.com> wrote:
> This one is going to be fun, since it's a hard reset back to bios, no
> OOPS or anything shown.  It may be about the time RadeonFB kicks in,
> but it's impossible to tell.  I'd guess 15-20 lines into dmesg.
>
> I'm in the process of bisecting, currently 94c18227..d23cf676.
>
> Any guesses of a specific patch to check?

Except it's not d23cf676, that was the version I was running while
building HEAD, whoops.
I'm used to monotonic version numbers, not SHA hashes.  I'll keep
better track next time.

For completeness, the commit that caused boot to fail was:

commit ab144f5ec64c42218a555ec1dbde6b60cf2982d6
Author: Andi Kleen <ak@suse.de>
Date:   Fri Aug 10 22:31:03 2007 +0200

    i386: Make patching more robust, fix paravirt issue

Except I'm using x86_64?  So not sure why that one rev kills me.
ACPI? It dies right after the CPU is identified:
CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00
ACPI: Core revision 20070126

I don't think that second line is printed on the crash.

However, a git-pull at 2am (b8d3f244) fixed it.  Not sure where in
there it started working again, I can bisect backwards to find out if
need be.
