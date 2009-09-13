Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZIMHBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZIMHBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 03:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZIMHBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 03:01:30 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:40483 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZIMHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 03:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bfF/A4s/h8uMBKkWARA0G00oJ0iJf4QdodMLEN5PltxUtBYb0N8CoXC4LyUrgJPt7Y
         1KWhl+JeWiv3++5ay8QvctzEnKo3goNMKjbSDVFxroVi8Btacn2DzS8GkFHZ4ucWHLBo
         jmWO+gN/1Azk4RRVaAnctHSOr963RbMuZ5iFg=
Message-ID: <4AAC98C9.3050005@gmail.com>
Date: Sun, 13 Sep 2009 01:01:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's in libata-dev.git?
References: <20090911064246.GA8422@havoc.gtf.org>
In-Reply-To: <20090911064246.GA8422@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 12:42 AM, Jeff Garzik wrote:
>
> This is a summary of the changes current queued on the #upstream branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>
> These will be pushed to Linus in the next day or so, when merges start
> flowing.
>
> linux-ide hackers, speak up is something is obviously wrong or missing.
>
> The only outstanding patch is Robert Hancock's enhance-command-parsing
> patch:  I'm still on the fence about leaving the huge switch table, or
> choosing a better data structure.

I just tried implementing some table-based code to achieve something 
like what the patch I posted was doing. The combined code+data size was 
only marginally smaller (about a 3K increase versus 4K with the switch 
version), the function was about the same number of lines, it would be 
slower (scanning through a table rather than the compiler-generated jump 
table, though it's not like it's used on a hot path anyway) and it's 
also less flexible. Particularly with some weird commands (like the way 
they seem to be heading with the DATA SET MANAGEMENT command where the 
feature register is being used as a bitmask instead of a simple command 
code), it would be a lot simpler to implement that in a switch statement 
rather than having to modify an entire table structure to accommodate it.

So essentially my advocated patch is unchanged after that experiment. It 
may not be the prettiest thing in the world, but I'm not sure it really 
gets much better..
