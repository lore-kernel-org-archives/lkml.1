Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZFEDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZFEDIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZFEDHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:07:55 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35129 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZFEDHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IC1WEKPP3ZoNPvE/tPDeeWmAHu8pnZjlfiIa32R+xeGwlmmXhlz1XYkN4HQ8It4rq4
         /yb8KqyU82SyghvyQdM8s0/Swimp9DJ5CXenyopIdDIW2iwYeii1nN6cQl8dHRhFS1ch
         p6v7+UHJhgHbUUAsAF8JygYCdi7jWolzpF+qM=
MIME-Version: 1.0
In-Reply-To: <200906031101.56577.rjw@sisk.pl>
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se>
	 <200906012133.32074.rjw@sisk.pl>
	 <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
	 <200906031101.56577.rjw@sisk.pl>
Date: Fri, 5 Jun 2009 12:07:56 +0900
Message-ID: <aec7e5c30906042007t26915c05rd8ef375b8d4a353c@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 6:01 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Tuesday 02 June 2009, Magnus Damm wrote:
>> If you guys dislike adding arch specific data to struct platform
>> device then for SuperH we can just (mis)use the arch specific data in
>> struct device instead. I'm afraid that solution wastes memory since
>> the data will only be used for platform devices anyway. So I prefer
>> adding arch specific data to struct platform_device instead of struct
>> device if possible.
>
> BTW, what is the difference really?  You can always put
> dev.platform_data = NULL for devices that don't have any platform data,
> can't you?

So the convention is that dev.platform_data points to driver-specific
data. It may or may not be required by the driver. The format of this
data is driver specific and should be the same across architectures.

What I'm trying to add with struct pdev_archdata is a place for
architecture specific data. This data is needed by architecture
specific code (for example runtime PM), and since it's architecture
specific it should _never_ be touched by device driver code. Exactly
like struct dev_archdata but for platform devices.

Like I said, we _could_ use struct device for this purpose, but it
sounds like suboptimal software design to me. Using struct device
means that we put data where it doesn't belong. I'd like to add
_platform_ _device_ _specific_ data, not data that should be present
in all struct devices in the system but only used in some cases.

Cheers,

/ magnus
