Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbYIUNx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbYIUNx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 09:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYIUNxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 09:53:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYIUNxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 09:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=Y/+JuCiPujdLM/jyC9uL5/vnQDBxRvBRrAGxokGjgRl3gqzavWA6b0ZPJRucBb+TmL
         Ma6OSUXB75jS5tRlq5BDPOrpkAC43ulGTXX294s2HGOmScoWRjM/Bm5tfiFFxqk7aw6o
         4tv49xG0lbYO4zAz8CbScFOLQPqoIDHloppFU=
Message-ID: <76bd70e30809210653o304d6634k9e1f11263db6452a@mail.gmail.com>
Date: Sun, 21 Sep 2008 09:53:14 -0400
From: "Chuck Lever" <chuck.lever@oracle.com>
Reply-To: chucklever@gmail.com
To: "Martin Knoblauch" <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Banks" <gnb@melbourne.sgi.com>,
       "linux-nfs list" <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Peter zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <968192.84087.qm@web32607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <968192.84087.qm@web32607.mail.mud.yahoo.com>
X-Google-Sender-Auth: 311d727e95581e62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 8:50 AM, Martin Knoblauch <knobi@knobisoft.de> wrote:
> ----- Original Message ----
>
>> From: Chuck Lever <chucklever@gmail.com>
>> To: Martin Knoblauch <knobi@knobisoft.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>; Greg Banks <gnb@melbourne.sgi.com>; linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org; Peter zijlstra <a.p.zijlstra@chello.nl>
>> Sent: Thursday, September 18, 2008 8:24:42 PM
>> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
>>
>> On Thu, Sep 18, 2008 at 6:53 AM, Martin Knoblauch wrote:
>> > ----- Original Message ----
>> >
>> >> From: Andrew Morton
>> >> To: Martin Knoblauch
>> >> Cc: Greg Banks ; linux-nfs list
>> ; linux-kernel@vger.kernel.org; Peter zijlstra
>>
>> >> Sent: Thursday, September 18, 2008 10:47:33 AM
>> >> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
>> >>
>> >> On Thu, 18 Sep 2008 01:38:57 -0700 (PDT) Martin Knoblauch
>> >> wrote:
>> >>
>> >> > > No.  mount(8) will pass unrecognised options straight down into the
>> >> > > filesystem driver.
>> >> > >
>> >> >
>> >> >  Has that always been the case, or is it a recent change? I have to support
>> >> RHEL4 userland, which is not really new.
>> >>
>> >> It's been that way for ever and ever.  It's how all these guys:
>> >>
>> >> y:/usr/src/25> grep Opt_ fs/*/super.c|wc
>> >>     781    2626   33703
>> >>
>> >> get handled.
>> >
>> >  while that seems to be not to complicated, I seem to have a problem passing
>> the mount options to the kernel. They come down as mount data version "6".
>> Apparently mount(8) or mount.nfs(8) are doing the parsing and send down the
>> legacy data block. So, what is the minimum version of mount or mount.nfs that
>> pass the options down unaltered?
>>
>> The mount command has passed a string of options to the kernel for
>> particular file systems for a while, but the facility for the NFS
>> client to parse a string of mount options in the kernel was added only
>> recently -- at least 2.6.23 or 2.6.24 is required to support this.
>> Before this, the mount command parsed these options.
>>
>
>  I understand that. Question remains, which version of the mount(8) or nfs.mount(8) command do I need to pass the options to the kernel.

You can use the latest version of nfs-utils, which is 1.1.3 to get a
version of mount.nfs that passes a string of mount options.

You should probably also replace the mount command with the latest
version from the util-linux package to get a version that starts the
mount.nfs subcommand instead of trying to do an NFS mount itself.

This is not needed for experimentation, though.  You can issue
mount.nfs directly.

--
Chuck Lever
