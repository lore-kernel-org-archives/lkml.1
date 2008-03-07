Return-Path: <linux-kernel-owner+w=401wt.eu-S1762456AbYCGBzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762456AbYCGBzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYCGBz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:55:28 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:64092 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYCGBz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:55:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rsa/6w1N66E0bC6JjNWavlTbb2ibQuJJ/5R8ajGErepHja2P0yIf681cruROA0bdvoL6T1a16lx1TlhlyiXub2FsysrMYeM4x+p1U+w9p31k+rCC/FZtBKqwDofc5mtx1ZQSruEFfcp9V0vfF69OBhyES4vDKSX2KnFjHWo8KRs=
Message-ID: <43e72e890803061755x17b2a626xddd7dd71a92a80c5@mail.gmail.com>
Date: Thu, 6 Mar 2008 20:55:24 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [RFC] Linux central regulatory domain agent - next stage
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, "Jouni Malinen" <j@w1.fi>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Sam Leffler" <sam@errno.com>, "Dan Williams" <dcbw@redhat.com>,
       "Ivan Seskar" <Seskar@winlab.rutgers.edu>,
       "Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Tim Gardner" <tim.gardner@canonical.com>,
       "Jean Tourrilhes" <jt@hpl.hp.com>
In-Reply-To: <200803051132.24020.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890802261555i37d8f470q9ac16df8140740fe@mail.gmail.com>
	 <200803051132.24020.bruno@thinktube.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 9:32 PM, bruno randolf <bruno@thinktube.com> wrote:

>  > My preference is to keep the real database on a development box which
>  > has some web interface which people can use to view. Ideally users can
>  > then send updates to the database to provide updates to rules. The
>  > database can then be dumped and an application used to generate some
>  > flat file. Distributions can then pick this flat file up and propagate
>  > it to users. A user's host would have the CRDA userspace daemon
>  > running, and once a new file is downloaded the regulatory daemon is
>  > informed about it. The reg daemon would then parse the flat file and
>  > update its internal database and new regulatory rules would become
>  > available to the kernel. What I am not sure on is the best format to
>  > use for the flat file.
>
>  if at all, i'd suggest a simple binary format for that file. it's not that we
>  would have to do a lot of searching thru it, so i think something
>  database-like is not necessary. also it has to be included in embedded
>  systems so it should be quite small. a text-based approach would make it too
>  easy for users to change and override regulatory settings. i know the basic
>  idea is to put the liability to the user, but at the same time i think we
>  should not make it too easy to alter the regulatory rules.

I second a binary file format but not for security purposes -- instead
I second it to reduce the size and make it easily readable to the
regulatory daemon. Although I acknowledge the importance of obeying
local regulatory laws by no means do I think this should interfere
with us coming up with the best possible solution to the problem. I
also envision that down the road we'd want to make it easy to
automatically change current restrictions not due to regulatory rules
but instead to enhance communication dynamically based on currently
read wireless trends in your local environment. We don't want to lock
users but enable them and assist them in obeying local regulatory
laws. Hardware vendors, on the other hand, are currently legally tied
to strictly obeying local regulatory restrictions or at least their
attorney's interpretation of such laws but that doesn't mean that its
right too or that their attorney's interpretation is right. Security
through obscurity simply does not work for restricting devices and
having laws that stick to this philosophy and supporting it deters
technology and communication in the end instead of enhancing them
which IMHO *is* the purpose of regulatory agencies.

>  actually i think the best way to keep and update the regulatory table is as
>  part of a source tree! instead of building a huge new infrastructure - a
>  server with a db which users can upload regulatory changes to, a review
>  process for these changes, a file export for downloading the latest db, a
>  file format for keeping the db on the host and then parsing them into the
>  application - why not just maintain the regulatory rules as part of the
>  source tree and use the processes (version management, peer review) we
>  already have in place there?

Well the whole notion of using a db was for the purpose of
presentation and for easy review. I'd like to make it easy for
non-developers to contribute changes to the regulatory db. My v2
patches kept regulatory domains in C files in structs which basically
were tables with some sort of shared key. I have to say that while
trying to update them even I found it difficult and sometimes made
easy mistakes. To easily view regulatory domain restrictions I think
what's easiest is some sort of HTML table online for each regulatory
domain.

For patching purposes I think you're right and that its easiest
through patches as that is what we're used to. But I can also see SQL
statements for modifications working or plain English proposals which
maintainers can then translate to SQL or just alter through a DB admin
interface. I guess either way its easy to make mistakes. One way or
another we do need a way to make the db easily visible and we also
need that binary end file. A db seems nice as you can easily query
data and do whatever you want with it. If we keep it in C files a db
database would need to be drop'd and created each time changes are
made. If you don't use a DB I don't know how you can make the
regulatory db easily visible.

>  well, which source tree? i don't really know. iw maybe?

Hm, was actually thinking of splitting up some stuff for licensing
purposes. More on this below.

> or would'nt it make
>  sense to make a library which can be used by iw, wpa_supplicant, hostapd and
>  other applications alike to access the wireless settings, including
>  regulatory domains?

Definitely, although I'd like to separate our own tools and the
central reg daemon/libs to reading/parsing reg domains on a binary
file. This is because I'd like to work together with the BSD family on
a decent reg db. I think we can both benefit by working on this
together, just like with radiotap. Operating System-wise the parsing
of the file can remain the same but what we would differ in is what we
do with the info we parse. For example I expect a regdaemon to sit
there and have at its disposal all available regulatory info. Should
we need to change country/regdomain manually we can use iw. iw will
query the regulatory daemon for its desired regulatory domain, return
it to iw and then iw can use nl80211 to upload it to the kernel.
Another example, should an 802.11d frame arrive and the wireless
subsystem accepts it to change regdomain the kernel can query the
regulatory daemon using nl80211 to get its regulatory domain. I would
want the regulatory daemon licensed under the ISC/BSD and our tools
can simply keep with the GPL tradition.

  Luis
