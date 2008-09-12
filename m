Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYILUc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYILUc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYILUcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:32:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:37328 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYILUcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FpoVKZetFYkRyu7reClgbzedymt8f4FR1e2SOjUQDmQJJkIMjYKUqfeHTBXFiUAJ6m
         PgRWuJ69yohb629XisYvVIJzmrxV9LlQBkBIMPaDh9edBMVSb7QRo9T3ehV2MJf383F6
         CNU76xUjGumc+sR71lJ/Wla8acXUI3RJaJzUc=
Message-ID: <7af24c80809121332s5747b4favdfd7adb187d4e73a@mail.gmail.com>
Date: Fri, 12 Sep 2008 22:32:48 +0200
From: "Kai Henningsen" <kai.extern@googlemail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [RFC/PATCH] dontdiff: generate from gitignore
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
In-Reply-To: <48CAA9D4.4090000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080901150951.5cba4dc7@infradead.org>
	 <20080901231419.GA5602@x200.localdomain>
	 <20080912101840.e0b6dd8c.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0809121025460.3300@nehalem.linux-foundation.org>
	 <48CAA9D4.4090000@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 19:41, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Linus Torvalds wrote:
>>
>> On Fri, 12 Sep 2008, Randy Dunlap wrote:
>>> Generate the "dontdiff" file from the .gitignore files.
>>
>> t's not quite as simple as that, though.
>>
>> The .gitignore files are fundamentally location hierarchy-aware, so a
>> ignore entry in one subdirectory only affects that subdirectory
>> (recursively), so if you flatten then, you should take that into account.
>>
>> As far as I can tell, your script will generate lots of incorrect entries
>> due to this. Eg, it will generate
>>
>>       parse.[ch]
>>
>> as a dontdiff pattern, because scripts/genksyms/.gitignore has that, but
>> that means that now it will ignore parse.c in all the _other_ places,
>> where it *isn't* a generated file (ie mm/parse.c).
>
> Yes, that's one of the reasons that it contains "RFC" in $subject.
> There's also no handling of !pattern .gitignore lines....
>
> AFAIK, diff with a dontdiff file does not allow/support full pathname
> hierarchies like .gitignore does, so this is probably a futile exercise.  ??

I'm presuming you're talking about this diff option?

`-X FILE'
`--exclude-from=FILE'
     When comparing directories, ignore files and subdirectories whose
     basenames match any pattern contained in FILE.  *Note Comparing
     Directories::.

Indeed: it clearly says "basename" here.

If it weren't for that, you could just use git-ls-files --ignore to
find them ...
