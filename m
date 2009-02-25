Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbZBYD20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbZBYD20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 22:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZBYD2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 22:28:17 -0500
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:25454 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754250AbZBYD2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:28:16 -0500
X-YMail-OSG: oMPouQ4VM1mF58bwcdfPE5Jmz5Q56YUEf6qSRutIGwnIuIJh5NuSSmvbKdW7L1R4x2wDIzTKr3IHWm_5jaZRgj6Pgz4v2gn17j7Hau3H3f3uaDQ3HN5MP3H1TkBuwKWRiqCmMI1OSBhCcuphmEFjA00wBGxqxosPc9d8uXEPDGjJ_..OioOkn_EWpCwOz5MjvA8o4a2pBqdCO.3uEO37iMqANyUR_0R9IGQp8wZnJQN_24a3j2YB15bGgXK314xsZER2pbK3pVaEXPJkOWlnBiivDWPiXBamSAOA
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49A4BAC8.30708@schaufler-ca.com>
Date: Tue, 24 Feb 2009 19:28:08 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: etienne <etienne.basset@numericable.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH][SMACK] add a socket_post_accept hook to fix netlabel
 issues with labeled TCP servers V1
References: <fa.eUdEnVYPYgnfwD9aw1dVY6gL1+E@ifi.uio.no> <200902241738.08877.paul.moore@hp.com> <49A47BEF.5030507@numericable.fr> <200902241836.59679.paul.moore@hp.com>
In-Reply-To: <200902241836.59679.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> ...
>> well, i think it is simple : let's say i want to run a "smack-labelled
>> server" (apache, vsftpd, ...) clients connect from internet,  so the server
>> admin/user  will want to add a "0.0.0.0/0 @" entry in netlabel that will
>> _fail_ because the server will send back "labeled" packets.
>>     
>
> I had to go back and look at the address based labeling patches, I had somehow 
> forgotten that the single label support in Smack can only be used for removing 
> labels, not adding them.  With that in mind your approach should work although 
> you will still get really bizarre behavior in the following case:
>
>  * Service not running at the ambient label
>  * Only address based label loaded into Smack is "0.0.0.0/0 @" (everything
>    unlabeled)
>  * Client connects to service using labeled networking
>
> If you and Casey can live with labeled connection suddenly becoming unlabeled 
> (I doubt the remote host will deal with it very gracefully) then go for it.
>   

The case where the netlabel entry "0.0.0.0/0 @" has been added
will unfortunately be a very common case because it say that while
the local machine does MAC the world as a whole does not. It also
means that the admin does not understand the implication that
local networking will no longer enforce MAC controls, or that for
some bizarre reason that it what he wants. In either case it is
very unlikely that he expects to connect to another system that
speaks CIPSO. For that reason I expect that the "bizarre behavior"
of labeled hosts to be quite rare.

I think that it might be necessary to introduce mechanism to specify
labeled hosts in addition to unlabeled hosts. That way one could
specify:
    0.0.0.0/0       @
    127.0.0.1       CIPSO
    192.168.1.103   CIPSO

and let everyone except the local host be unlabeled while the local
host enforces Real MAC policy.

I personally find it reprehensible that the attitude that network
communications ought to be exempt from access controls is so
pervasive, but I bend to the will of the people. The interest in
Smack since the introduction of the web ("@") label has grown
dramatically.

I am still reviewing and verifying these patches, which look
fine so far, but I know better than to let my eyes make the
call when I have computers that are so much better at finding
software flaws.

Thank you again for the work and reviews. I am working on my
end. Really.


