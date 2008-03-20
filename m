Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYCTCb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYCTCb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYCTCbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:31:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:52309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbYCTCbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:31:18 -0400
From: "NeilBrown" <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Thu, 20 Mar 2008 13:31:07 +1100 (EST)
Message-ID: <58229.192.168.1.70.1205980267.squirrel@neil.brown.name>
In-Reply-To: <20080319223221.GL25636@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz>
    <20080312160007.GA10015@fieldses.org>
    <20080313143631.GH27873@ics.muni.cz>
    <20080314181413.GF2119@fieldses.org>
    <20080314193350.GK2119@fieldses.org>
    <20080314195303.GA4390@ics.muni.cz>
    <20080314200510.GL2119@fieldses.org>
    <20080314234205.GO2119@fieldses.org>
    <18397.43768.705353.514972@notabene.brown>
    <20080319223221.GL25636@fieldses.org>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Cc: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 20, 2008 9:32 am, J. Bruce Fields wrote:
> On Mon, Mar 17, 2008 at 10:19:20AM +1100, Neil Brown wrote:
>> On Friday March 14, bfields@fieldses.org wrote:
>> > On Fri, Mar 14, 2008 at 04:05:10PM -0400, bfields wrote:
>> > > I find that a little contorted.  So I'll go ahead and submit this
>> small
>> > > patch to 2.6.25 and stable now (I have since managed to reproduce
>> what I
>> > > believe is your bug, though my symptoms were a little different),
>> and
>> > > then submit to 2.6.26 some cleanup which makes this more
>> understandable,
>> >
>> > Here's an attempt.  We could break up fh_verify even more, though.--b.
>>
>> Looks like a good attempt.
>>
>> My only suggestion would be to put a comment at the top of
>> nfsd_set_fh_dentry explaining what it does and who calls it.
>
> OK!  I'm planning to just add:
>
> +/*
> + * Use the given filehandle to look up the corresponding export and
> + * dentry.  On success, the results are used to set fh_export and
> + * fh_dentry.
> + */
>  static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh
> *fhp)
>  {
>  	struct knfsd_fh	*fh = &fhp->fh_handle;
>
> (Nothing about "who calls it", but it's static and its only caller is
> fh_verify, so that seemed uninteresting.)  Anything else you were
> looking for?

No, that's adequate.
The function name has one verb and 2 (or 3) nouns,  and it isn't clear
how the verb relates to the nouns.  The comment you gave makes that
clear.

Thanks,
NeilBrown

