Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbZCMSiS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 13 Mar 2009 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbZCMSiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:38:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:55220 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbZCMSiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wD1S520JuDj4DSIDUL4gxWuTGI8M7MT2BlzelnKPG74NbSIiNdE8dcZKYVW2Zop41q
         aS5qDDHhYtiXZA1TlN5YayoaQEsR4ckbxaQQkimEnywTgVeWISp8jyrfAPPvDXO1aVSx
         v5Jh4EvfPxEu4nvSjCJ8ljcni0llRJ2WUxNJc=
MIME-Version: 1.0
In-Reply-To: <20090313175848.GB27891@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org>
	 <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
Date: Fri, 13 Mar 2009 18:37:55 +0000
Message-ID: <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
Subject: =?KOI8-R?Q?=EF=D4=D7=C5=D4=3A_VFS=2C_NFS_security_bug=3F_Should_CAP=5FMKNOD_?=
	=?KOI8-R?Q?and_CAP=5FLINUX=5FIMMUTABLE_be_added_to_CAP=5FFS=5FMASK=3F?=
From: Igor Zhbanov <izh1979@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
   "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
   viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
   David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But ordinary users can't create devices. It seems to me that in time
of implementation of capabilities in kernel 2.4, capabilities related
to filesystem was added first. And mark for them contains all above in
header file. And when CAP_MKNOD was added later, author just forget to
update mask.

If mask was designed to drop all filesystem related capabilities, then
it must be expanded, because ordinary users cannot create devices etc.

2009/3/13, J. Bruce Fields <bfields@fieldses.org>:
> On Fri, Mar 13, 2009 at 09:21:23AM +1300, Michael Kerrisk wrote:
>> On Fri, Mar 13, 2009 at 5:10 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>> > Quoting J. Bruce Fields (bfields@fieldses.org):
>> >> On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
>> >> > Hello!
>> >> >
>> >> > It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
>> >> > added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
>> >> > linux-2.4.x. Both capabilities affects file system and can be
>> >> > considered file system capabilities.
>> >>
>> >> Sounds right to me--I'd expect rootsquash to guarantee that new device
>> >> nodes can't be created from the network.  Cc'ing random people from the
>> >> git log for include/linux/capability.h in hopes they can help.
>> >
>> > Yeah it seems reasonable.  If it is, then does that mean that we
>> > also need CAP_SYS_ADMIN (to write selinux labels) and CAP_SETFCAP
>> > (to set file capabilities) as well?
>>
>> If a change is made to CAP_FS_MASK, please do remember to CC
>> mtk.manpages@gmail.com, and linux-api@.
>
> OK, that's because the exact set of capabilities that is dropped on
> setfsuid is documented in capabilities(7)?  (Anywhere else?)
>
> --b.
>
>>
>> Cheers,
>>
>> Michael
>>
>>
>> --
>> Michael Kerrisk Linux man-pages maintainer;
>> http://www.kernel.org/doc/man-pages/ Found a documentation bug?
>> http://www.kernel.org/doc/man-pages/reporting_bugs.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
