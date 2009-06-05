Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbZFEKUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbZFEKUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFEKUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:20:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZFEKUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:20:05 -0400
Message-ID: <4A28F1CD.6040804@redhat.com>
Date: Fri, 05 Jun 2009 18:22:05 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch] kbuild: fix headers_check.pl
References: <20090605021419.7905.89870.sendpatchset@localhost.localdomain> <200906051021.51726.arnd@arndb.de>
In-Reply-To: <200906051021.51726.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 05 June 2009, Amerigo Wang wrote:
>   
>> -sub check_prototypes
>> +sub check_declarations
>>  {
>> -       if ($line =~ m/^\s*extern\b/) {
>> -               printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
>> +       if ($line =~m/^\s*extern\b/) {
>> +               if ($line =~ m/^\s*extern\b.*\(.*\)/) {
>> +                       printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
>> +               } else {
>> +                       printf STDERR "$filename:$lineno: exporting global variable to userspace is suspicious\n";
>> +               }
>>         }
>>  }
>>     
>
> I don't think we really need that distinction here, the old
> text applies to both.
Even for function declarations?
> But please find a way to get rid of
> the "extern's".
>   
Here, that one has already been removed by other patch ...

