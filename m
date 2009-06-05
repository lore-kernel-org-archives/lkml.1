Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZFEL3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZFEL3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZFEL3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:29:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38043 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZFEL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:29:04 -0400
Message-ID: <4A2900E9.1050005@gmail.com>
Date: Fri, 05 Jun 2009 14:26:33 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch] kbuild: fix headers_check.pl
References: <20090605021419.7905.89870.sendpatchset@localhost.localdomain> <200906051021.51726.arnd@arndb.de>
In-Reply-To: <200906051021.51726.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 11:26:39.0426 (UTC) FILETIME=[7E740220:01C9E5D0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 05 June 2009, Amerigo Wang wrote:
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
> 
> I don't think we really need that distinction here, the old
> text applies to both. But please find a way to get rid of
> the "extern's".
> 
> http://angryflower.com/bobsqu.gif

Hehe, made me smile :-)
