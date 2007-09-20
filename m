Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXITLvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXITLvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXITLvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:51:13 -0400
Received: from sa8.bezeqint.net ([192.115.104.22]:40234 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbXITLvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:51:11 -0400
From: Shlomi Fish <shlomif-lkml@freehackers.org>
To: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement (rev8)
Date: Thu, 20 Sep 2007 13:50:43 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200709132252.20719.shlomif@freehackers.org> <Pine.LNX.4.64.0709160043430.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0709160043430.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201350.43553.shlomif-lkml@freehackers.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sorry for the late response.

On Sunday 16 September 2007, Roman Zippel wrote:
> Hi,
>
> On Thu, 13 Sep 2007, Shlomi Fish wrote:
> > This patch adds an option to use either substring match, regular
> > expression match, or keywords search in the "make xconfig" Edit->Find
> > dialog.
> >
> > It also allows searching on the "help" field of the menus as well as
> > the "name" of the symbol.
> >
> > This change involved adding the sym_generic_search function to the LKC,
> > and implementing sym_re_search using it.
>
> I like the direction, but first of all please fix the coding style.

Which specific problems do you see with the coding style of the patch? Can you 
comment on it?

> I would also prefer to move more of the search functionality into the
> generic code, so it can be used by other front ends as well, otherwise a
> lot of this had to be duplicated.

That would be a good idea, but I cannot use Qt there, which makes my job 
harder.

> I think a filter function makes it maybe a bit to flexible, if a front
> end wants to do some weird filtering, it can still access the symbol
> data base directly. 

A filter function would still be convenient in this context, as the symbol 
data base API may change, and the filter function has a little logic in it.

> So what I have in mind is something like this: 
>
> struct symbol **sym_generic_search(const char *pattern, unsigned int
> flags);
>
> This means the back end provides a basic search facility for the most
> common search operations. The flags would specify what to search (e.g.
> symbol name, help text, prompts) and how to do it.

I suggest we don't call it sym_generic_search, as generic implies it is a 
generic filter. We can call it "sym_string_search" or whatever. Then, I 
suggest we have separate arguments for every parameter (i.e: search type, 
case sensitivity, what to search, etc.).



>
> > @@ -1199,6 +1199,23 @@
> >  	layout2->addWidget(searchButton);
> >  	layout1->addLayout(layout2);
> >
> > +	// Initialize the "Search Type" button group.
> > +	searchType = new QVButtonGroup("Search Type", this, "searchType");
> > +
> > +	substringSearch = new QRadioButton(
> > +		"Substring Match", searchType, "Substring Match"
> > +		);
> > +
> > +	keywordsSearch = new QRadioButton("Keywords", searchType, "Keywords");
> > +
> > +	regexSearch = new QRadioButton(
> > +		"Regular Expression", searchType, "Regular Expression"
> > +		);
> > +
> > +	substringSearch->setChecked(TRUE);
> > +	layout1->addWidget(searchType);
> > +
> > +	// Initialize the ConfigView and ConfigInfoView
> >  	split = new QSplitter(this);
> >  	split->setOrientation(QSplitter::Vertical);
> >  	list = new ConfigView(split, name);
> > @@ -1245,6 +1262,20 @@
> >  	}
> >  }
> >
> > +SEARCH_TYPE ConfigSearchWindow::getSearchType()
> > +{
> > +	return	substringSearch->isChecked() ? SUBSTRING :
> > +		regexSearch->isChecked() ? REGEX :
> > +		KEYWORDS;
> > +}
>
> If you use QButtonGroup::insert() you can assign id's to the indivual
> buttons and then use selectedId to make this part simpler.
>

Ah, OK.

Regards,

	Shlomi Fish

---------------------------------------------------------------------
Shlomi Fish      shlomif@iglu.org.il
Homepage:        http://www.shlomifish.org/

If it's not in my E-mail it doesn't happen. And if my E-mail is saying
one thing, and everything else says something else - E-mail will conquer.
    -- An Israeli Linuxer
