Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbZHQEug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbZHQEug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 00:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZHQEuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 00:50:35 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:55912 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHQEue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 00:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <2359eed20908152124s1af8d95eu7d4706ec3a50bc33@mail.gmail.com>
References: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
	 <20090814133225.GB27905@us.ibm.com>
	 <2359eed20908140840u2886b8dci4ce72914fc2b1ea9@mail.gmail.com>
	 <551280e50908151022tde71278gc0a745c52a8415ed@mail.gmail.com>
	 <2359eed20908152124s1af8d95eu7d4706ec3a50bc33@mail.gmail.com>
Date: Sun, 16 Aug 2009 21:50:34 -0700
X-Google-Sender-Auth: 7c8526ebf40bcf30
Message-ID: <551280e50908162150g3764d6caqf4de130befb7789f@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/1] support optional non-VFS capability inheritance 
	without disabling file caps
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Will Drewry <redpig@dataspill.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

I've read this over a few times, but the in-lining is confusing me.
The idea of tying privilege only to 'anointed' binaries is the "POSIX"
capabilities model.

If you are willing to concede that one can always arrange xattrs to be
convenient with various filesystem mounting techniques, are you saying
you would like all executables to be able to wield privilege if their
parent wants to give it to them?

Thanks

Andrew

On Sat, Aug 15, 2009 at 9:24 PM, Will Drewry<redpig@dataspill.org> wrote:
> On Sat, Aug 15, 2009 at 12:22 PM, Andrew G. Morgan<morgan@kernel.org> wrote:
>> Naive process inheritance of privilege is one of the things this whole
>> infrastructure is trying to discourage...
>
> Hrm I know that was more of the intent of POSIX file capabilities
> (AFAICT), but I was under the impression that the full picture of
> capabilities in linux were more about moving away from a default-on,
> binary superuser privilege policy.  But you'd know what your intentions
> were better than me :)
>
> I was hoping that a process inheritance approach wouldn't be considered
> the same as root inheritance is now.  It operates with the same
> granularity as the file-based approach except that it allows these
> lesser privilege sets to be limited in time for a binary. E.g.,
> it'd be nice if pulseaudio could be started with privileges only at,
> let's say, login-time for a user and not when a remote attacker needs to
> bypass mmap_min_addr.
>
>> Overlays aside, is there some limit on the sophistication of your
>> filesystem setup? Presumably, one could create a small filesystem in a
>> file and, using the loopback device, mount it. Such a filesystem could
>> have xattrs ACLs and filecaps and give you all the specificity you
>> need for this purpose. /chroot/mnt/sbin/ etc.
>
> That's a perfectly nice workaround (especially since it'd be easy enough
> to pair with some symlinks), but I am interested in both issues --
> xattr-less filesystems and the inflexibility of filesystem-based
> security policy.
>
> If the patch (and my intentions) are irreconcilably at odds with the
> capability system (and securebits) goals, then I can definitely evaluate
> other avenues as well as revisit the underpinnings of my plans.  I was
> just hoping that this would fit in under the current umbrella (e.g., like
> the other root-to-capability-mode transition fixups).
>
> If it's a hopeless case, please let me know!  However, I'm happy to
> make any number of changes if something like this is feasible.
>
> thanks!
> will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
